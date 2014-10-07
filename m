Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572AbaJGOzJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 10:55:09 -0400
Received: from top.free-electrons.com ([176.31.233.9]:34738 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751795AbaJGOzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 10:55:06 -0400
Date: Tue, 7 Oct 2014 16:52:26 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Russell King <linux@arm.linux.org.uk>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Vinod Koul <vinod.koul@intel.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, dmaengine@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Antoine =?iso-8859-1?Q?T=E9nart?= <antoine@free-electrons.com>,
        Thomas Petazzoni <thomas@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris Brezillon <boris@free-electrons.com>,
        Matt Porter <matt.porter@linaro.org>,
        Gregory Clement <gregory.clement@free-electrons.com>
Subject: Re: [PATCH v2 2/2] Documentation: dmaengine: Add a documentation for
 the dma controller API
Message-ID: <20141007145226.GA17925@lukather>
References: <1411746035-15882-1-git-send-email-maxime.ripard@free-electrons.com>
 <1411746035-15882-2-git-send-email-maxime.ripard@free-electrons.com>
 <7725507.nuHj4C7OxF@avalon>
 <5433D9AF.8020508@atmel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PEIAKu/WMn1b1Hv9"
Content-Disposition: inline
In-Reply-To: <5433D9AF.8020508@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PEIAKu/WMn1b1Hv9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 07, 2014 at 02:16:47PM +0200, Nicolas Ferre wrote:
> Hi Maxime,
>=20
> First of all, thanks a lot for this needed documentation.
>=20
> I do my little comments on top of Laurent's ones.
>=20
>=20
> On 06/10/2014 14:09, Laurent Pinchart :
> > Hi Maxime,
> >=20
> > Thank you for working on this. Please see below for a couple of comment=
s in=20
> > addition to Randy's proof-reading.
> >=20
> > On Friday 26 September 2014 17:40:35 Maxime Ripard wrote:
> >> The dmaengine is neither trivial nor properly documented at the moment,
> >> which means a lot of trial and error development, which is not that go=
od
> >> for such a central piece of the system.
> >>
> >> Attempt at making such a documentation.
> >>
> >> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> >> ---
> >>  Documentation/dmaengine/provider.txt | 358 ++++++++++++++++++++++++++=
++++++
> >>  1 file changed, 358 insertions(+)
> >>  create mode 100644 Documentation/dmaengine/provider.txt
> >>
> >> diff --git a/Documentation/dmaengine/provider.txt
> >> b/Documentation/dmaengine/provider.txt new file mode 100644
> >> index 000000000000..ba407e706cde
> >> --- /dev/null
> >> +++ b/Documentation/dmaengine/provider.txt
> >> @@ -0,0 +1,358 @@
> >> +DMAengine controller documentation
> >> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >> +
> >> +Hardware Introduction
> >> ++++++++++++++++++++++
> >> +
> >> +Most of the Slave DMA controllers have the same general principles of
> >> +operations.
> >> +
> >> +They have a given number of channels to use for the DMA transfers, and
> >> +a given number of requests lines.
> >> +
> >> +Requests and channels are pretty much orthogonal. Channels can be used
> >> +to serve several to any requests. To simplify, channels are the
> >> +entities that will be doing the copy, and requests what endpoints are
> >> +involved.
> >> +
> >> +The request lines actually correspond to physical lines going from the
> >> +DMA-elligible devices to the controller itself. Whenever the device
> >> +will want to start a transfer, it will assert a DMA request (DRQ) by
> >> +asserting that request line.
> >> +
> >> +A very simple DMA controller would only take into account a single
> >> +parameter: the transfer size. At each clock cycle, it would transfer a
> >> +byte of data from one buffer to another, until the transfer size has
> >> +been reached.
> >> +
> >> +That wouldn't work well in the real world, since slave devices might
> >> +require to have to retrieve various number of bits from memory at a
> >> +time. For example, we probably want to transfer 32 bits at a time when
> >> +doing a simple memory copy operation, but our audio device will
> >> +require to have 16 or 24 bits written to its FIFO. This is why most if
> >> +not all of the DMA controllers can adjust this, using a parameter
> >> +called the width.
> >=20
> > DMA engines can have buses larger than 32 bits, I would thus phrase tha=
t as=20
> > follows.
> >=20
> > "That wouldn't work well in the real world, since slave devices might r=
equire=20
> > a specific number of bits to be transfered in a single cycle. For examp=
le, we=20
> > may want to transfer as much data as the physical bus allows to maximiz=
e=20
> > performances when doing a simple memory copy operation, but our audio d=
evice=20
> > could have a narrower FIFO that requires data to be written exactly 16 =
or 24=20
> > bits at a time. This is why most if not all of the DMA controllers can =
adjust=20
> > this, using a parameter called the transfer width."
> >=20
> >> +Moreover, some DMA controllers, whenever the RAM is involved, can
> >=20
> > s/the RAM is involved/RAM is used as a source or destination/ ?
> >=20
> >> +group the reads or writes in memory into a buffer, so instead of
> >> +having a lot of small memory accesses, which is not really efficient,
> >> +you'll get several bigger transfers. This is done using a parameter
> >> +called the burst size, that defines how many single reads/writes it's
> >> +allowed to do in a single clock cycle.
>=20
> Yes, here "single" word is used for different concepts and can have
> several meanings. We usually make the difference between "single"
> accesses and "burst" accesses.

Which was kind of what I was explaining, but it was probably not clear
enough.

>=20
> > The burst size defines "how many read or write operations can be queued=
 to=20
> > buffers before being flushed to memory". Several clock cycles will stil=
l most=20
> > likely be needed, the performance improvements here come from the fact =
that=20
> > the accesses can be performed in bursts.
> >=20
> >> +Our theorical DMA controller would then only be able to do transfers
> >> +that involve a single contiguous block of data. However, some of the
> >> +transfers we usually have are not, and want to copy data from
> >> +non-contiguous buffers to a contiguous buffer, which is called
> >> +scatter-gather.
> >> +
> >> +DMAEngine, at least for mem2dev transfers, require support for
> >> +scatter-gather. So we're left with two cases here: either we have a
> >> +quite simple DMA controller that doesn't support it, and we'll have to
> >> +implement it in software, or we have a more advanced DMA controller,
> >> +that implements in hardware scatter-gather.
> >> +
> >> +The latter are usually programmed using a collection of chunks to
> >> +transfer, and whenever the transfer is started, the controller will go
> >> +over that collection, doing whatever we programmed there.
> >> +
> >> +This collection is usually either a table or a linked list. You will
> >> +then push either the address of the table and its number of elements,
> >> +or the first item of the list to one channel of the DMA controller,
> >> +and whenever a DRQ will be asserted, it will go through the collection
> >> +to know where to fetch the data from.
> >> +
> >> +Either way, the format of this collection is completely dependent of
> >> +your hardware. Each DMA controller will require a different structure,
> >> +but all of them will require, for every chunk, at least the source and
> >> +destination addresses, wether it should increment these addresses or
> >> +not and the three parameters we saw earlier: the burst size, the bus
> >> +width and the transfer size.
> >=20
> > I would talk about "transfer width" here, as the transfer width can be =
smaller=20
> > than the bus width (I've even seen a strange case of a transfer width l=
arger=20
> > than the physical bus width).
> >=20
> >> +The one last thing is that usually, slave devices won't issue DRQ by
> >> +default, and you have to enable this in your slave device driver first
> >> +whenever you're willing to use DMA.
> >> +
> >> +These were just the general memory-to-memory (also called mem2mem) or
> >> +memory-to-device (mem2dev) transfers. Other kind of transfers might be
> >> +offered by your DMA controller, and are probably already supported by
> >> +dmaengine.
>=20
> I don't understand this part as you were talking about mem2dev and slave
> devices just above. I would just remove this last paragraph...

I wanted to introduce the XOR, interleaved, and all the other DMA
transfer variants that might be supported, beyond just memory to
device or memory to memory transfers.

>=20
> >> +
> >> +DMA Support in Linux
> >> +++++++++++++++++++++
> >> +
> >> +Historically, DMA controller driver have been implemented using the
> >=20
> > s/driver/drivers/
> >=20
> >> +async TX API, to offload operations such as memory copy, XOR,
> >> +cryptography, etc, basically any memory to memory operation.
> >> +
> >> +Over the time, the need for memory to device transfers arose, and
> >> +dmaengine was extended. Nowadays, the async TX API is written as a
> >> +layer on top of dmaengine, and act as a client. Still, dmaengine
> >> +accomodates that API in some cases, and made some design choices to
> >> +ensure that it stayed compatible.
> >> +
> >> +For more information on the Async TX API, please look the relevant
> >> +documentation file in Documentation/crypto/async-tx-api.txt.
> >> +
> >> +DMAEngine Registration
> >> +++++++++++++++++++++++
> >> +
> >> +struct dma_device Initialization
> >> +--------------------------------
> >> +
> >> +Just like any other kernel framework, the whole DMAEngine registration
> >> +relies on the driver filling a structure and registering against the
> >> +framework. In our case, that structure is dma_device.
> >> +
> >> +The first thing you need to do in your driver is to allocate this
> >> +structure. Any of the usual memory allocator will do, but you'll also
> >> +need to initialize a few fields in there:
> >> +
> >> +  * chancnt:	should be the number of channels your driver is exposing
> >> +		to the system.
> >> +		This doesn't have to be the number of physical
> >> +		channels: some DMA controllers also expose virtual
> >> +		channels to the system to overcome the case where you
> >> +		have more consumers than physical channels available.
> >=20
> > If I'm not mistaken the dma_async_register_device() function sets chanc=
nt=20
> > internally.
> >=20
> >> +  * channels:	should be initialized as a list using the
> >> +		INIT_LIST_HEAD macro for example
> >=20
> > More than that, drivers must fill that list before calling=20
> > dma_async_register_device().
> >=20
> >> +  * dev: 	should hold the pointer to the struct device associated
> >> +		to your current driver instance.
> >> +
> >> +Supported transaction types
> >> +---------------------------
> >> +The next thing you need is to actually set which transaction type your
> >=20
> > You can drop the "actually".
> >=20
> > s/type/types/
> >=20
> >> +device (and driver) supports.
> >> +
> >> +Our dma_device structure has a field called caps_mask that holds the
> >=20
> > s/caps_mask/cap_mask/
> >=20
> >> +various types of transaction supported, and you need to modify this
> >> +mask using the dma_cap_set function, with various flags depending on
> >> +transaction types you support as an argument.
> >> +
> >> +All those capabilities are defined in the dma_transaction_type enum,
> >> +in include/linux/dmaengine.h
> >> +
> >> +Currently, the types available are:
> >> +  * DMA_MEMCPY
> >> +    - The device is able to do memory to memory copies
> >> +
> >> +  * DMA_XOR
> >> +    - The device is able to perform XOR operations on memory areas
> >> +    - Particularly useful to accelerate XOR intensive tasks, such as
> >=20
> > s/- Particularly useful/  Used to/ ?
> >=20
> >> +      RAID5
> >> +
> >> +  * DMA_XOR_VAL
> >> +    - The device is able to perform parity check using the XOR
> >> +      algorithm against a memory buffer.
> >> +
> >> +  * DMA_PQ
> >> +    - The device is able to perform RAID6 P+Q computations, P being a
> >> +      simple XOR, and Q being a Reed-Solomon algorithm.
> >> +
> >> +  * DMA_PQ_VAL
> >> +    - The device is able to perform parity check using RAID6 P+Q
> >> +      algorithm against a memory buffer.
> >> +
> >> +  * DMA_INTERRUPT
> >> +    /* TODO: Is it that the device has one interrupt per channel? */
> >=20
> > If I'm not mistaken DMA_INTERRUPT means the device supports the=20
> > device_prep_dma_interrupt() operation, which prepares a dummy transfer =
that=20
> > will not transfer any data but will generate an interrupt, calling the=
=20
> > complete callback.
> >=20
> >> +
> >> +  * DMA_SG
> >> +    - The device supports memory to memory scatter-gather
> >> +      transfers.
> >> +    - Even though a plain memcpy can look like a particular case of a
> >> +      scatter-gather transfer, with a single chunk to transfer, it's a
> >> +      distinct transaction type in the mem2mem transfers case
> >> +
> >> +  * DMA_PRIVATE
> >> +    - The devices only supports slave transfers, and as such isn't
> >> +      avaible for async transfers.
> >> +
> >> +  * DMA_ASYNC_TX
> >> +    - Must not be set by the device, and will be set by the framework
> >> +      if needed
> >> +    - /* TODO: What is it about? */
> >> +
> >> +  * DMA_SLAVE
> >> +    - The device can handle device to memory transfers, including
> >> +      scatter-gather transfers.
> >> +    - While in the mem2mem case we were having two distinct types to
> >> +      deal with a single chunk to copy or a collection of them, here,
> >> +      we just have a single transaction type that is supposed to
> >> +      handle both.
>=20
> For transferring an unique buffer, simply build a collection with only
> one element.

Yep.

> >> +
> >> +  * DMA_CYCLIC
> >> +    - The device can handle cyclic transfers.
> >> +    - A cyclic transfer is a transfer where the chunk collection will
> >> +      loop over itself, with the last item pointing to the first. It's
> >> +      usually used for audio transfers, where you want to operate on a
> >> +      single big buffer that you will fill with your audio data.
> >=20
> > The buffer doesn't have to be big, I would s/big buffer/ring buffer/.
> >=20
> >> +
> >> +  * DMA_INTERLEAVE
> >> +    - The device supports interleaved transfer. Those transfers
> >> +      usually involve an interleaved set of data, with chunks a few
> >> +      bytes wide, where a scatter-gather transfer would be quite
> >> +      inefficient.
>=20
> Well, I don't know if it is related to efficiency. It is more another
> pattern for the transfer which is described by a "template": struct
> dma_interleaved_template.
> This mode is extremely flexible and due to its use of a different
> scatter-gather for source and destination can implement any memory
> organization. Think about 2D objects on a screen or picture-in-picture
> mode with consecutive addresses, holes, edges and frames boundaries.

True, thanks.

>=20
>=20
> > This is typically used to transfer 2D content such as uncompressed vide=
o.
> >=20
> >> +These various types will also affect how the source and destination
> >> +addresses change over time, as DMA_SLAVE transfers will usually have
> >> +one of the addresses that will increment, while the other will not,
> >> +DMA_CYCLIC will have one address that will loop, while the other, will
> >=20
> > s/the other,/the other/
> >=20
> >> +not change, etc.
>=20
> This is a little bit vague in my opinion. And usually, it is pretty
> implementation specific.

Which is why we can't really be more precise. If you have any other
wording coming to your mind, I'm all for it :)

> >> +Device operations
> >> +-----------------
> >> +
> >> +Our dma_device structure also requires a few function pointers in
> >> +order to implement the actual logic, now that we described what
> >> +operations we were able to perform.
> >> +
> >> +The functions that we have to fill in there, and hence have to
> >> +implement, obviously depend on the transaction types you reported as
> >> +supported.
> >> +
> >> +   * device_alloc_chan_resources
> >> +   * device_free_chan_resources
> >> +     - These functions will be called whenever a driver will call
> >> +       dma_request_channel or dma_release_channel for the first/last
> >> +       time on the channel associated to that driver.
> >> +     - They are in charge of allocating/freeing all the needed
> >> +       resources in order for that channel to be useful for your
> >> +       driver.
> >> +     - These functions can sleep.
> >> +
> >> +   * device_prep_dma_*
> >> +     - These functions are matching the capabilities you registered
> >> +       previously.
> >> +     - These functions all take the buffer or the scatterlist relevant
> >> +       for the transfer being prepared, and should create a hardware
> >> +       descriptor or a list of descriptors from it
> >> +     - These functions can be called from an interrupt context
> >> +     - Any allocation you might do should be using the GFP_NOWAIT
> >> +       flag, in order not to potentially sleep, but without depleting
> >> +       the emergency pool either.
> >=20
> > You could add "Drivers should try to preallocate the data structures th=
ey=20
> > require to prepare a transfer."
> >=20
> >> +
> >> +     - It should return a unique instance of the
> >> +       dma_async_tx_descriptor structure, that further represents this
> >> +       particular transfer.
> >> +
> >> +     - This structure can be allocated using the function
> >> +       dma_async_tx_descriptor_init.
> >=20
> > That function only initializes the tx descriptor, it doesn't allocate i=
t.
>=20
> Beware, it can be confusing when mixing "descriptors" and "hardware
> descriptors". The ones used by the DMA controller itself to describe the
> chunks of data (hardware descriptors) and the ones that would represent
> them in the driver (tx descriptors). However, it's true that both must
> be prepared by this set of functions.

There's a few "hardware" missing indeed, but we can't really avoid the
confusion here, since it does rely also on a dma_async_tx_descriptor.

> >> +     - You'll also need to set two fields in this structure:
> >> +       + flags:
> >> +		TODO: Can it be modified by the driver itself, or
> >> +		should it be always the flags passed in the arguments
> >> +
> >> +       + tx_submit:	A pointer to a function you have to implement,
> >> +			that is supposed to push the current descriptor
> >> +			to a pending queue, waiting for issue_pending to
> >> +			be called.
>=20
> The question remains: why wait when all the information is already
> prepared and available for the DMA controller to start the job?
> Actually, we don't wait in at_hdmac, just to be more efficient, but I
> known that we kind of break this "requirement"... But sorry, it is
> another discussion which should be lead elsewhere.

It's just a guess, but maybe you might not be able to schedule the
transfer right away? Think about a very dumb 1-channel (or a more
realistic more-DRQ-than-channel) device. You might have all the
channels busy doing some other transfers, and it's not really part of
the client driver job to address that kind of contention: it just
wants to queue some work for a later transfer.

> >> +
> >> +   * device_issue_pending
> >> +     - Takes the first descriptor in the pending queue, and starts the
> >> +       transfer. Whenever that transfer is done, it should move to the
> >> +       next transaction in the list.
> >> +     - It should call the registered callback if any each time a
> >> +       transaction is done.
>=20
> Can you clarify this?

The client driver might set up a callback, and it should be called
whenever that transaction is complete.

> >> +     - This function can be called in an interrupt context
> >> +
> >> +   * device_tx_status
> >> +     - Should report the bytes left to go over on the given channel
>=20
> The first aim of this function is to poll for transaction completion, if
> I recall well. It reports also if there was an error during the transfer.
>=20
> Moreover, I think it is not the number of "bytes" left, but the number
> of bytes using a granularity as described in enum
> dma_residue_granularity. All this depending on the capability of the
> controller to report such a value.

True.

> >> +     - Should also only concern about the given descriptor, not the
> >> +       currently active one.
> >=20
> > I have to guess what you mean here :-)
> >=20
> >> +     - The tx_state argument might be NULL
> >> +     - Should use dma_set_residue to report it
> >> +     - In the case of a cyclic transfer, it should only take into
> >> +       account the current period.
> >> +     - This function can be called in an interrupt context.
> >> +
> >> +   * device_control
> >> +     - Used by client drivers to control and configure the channel it
> >> +       has a handle on.
> >> +     - Called with a command and an argument
> >> +       + The command is one of the values listed by the enum
> >> +         dma_ctrl_cmd. To this date, the valid commands are:
> >=20
> > s/To this date, the/The/
> >=20
> >> +         + DMA_RESUME
> >> +           + Restarts a transfer on the channel
> >> +           + This command should operate synchronously on the channel,
> >> +             resuming right away the work of the given channel
> >> +         + DMA_PAUSE
> >> +           + Pauses a transfer on the channel
> >> +           + This command should operate synchronously on the channel,
> >> +             pausing right away the work of the given channel
> >=20
> > I think you should list DMA_PAUSE first, and then explain that DMA_RESU=
ME=20
> > resumes operation of a paused channel.
> >=20
> >> +         + DMA_TERMINATE_ALL
> >> +           + Aborts all the pending and ongoing transfers on the
> >> +             channel
> >> +           + This command should operate synchronously on the channel,
> >> +             terminating right away all the channels
>=20
> Is it a strong requirement to "terminate right away" all the transfers
> on the channel? Must the ongoing transfer be stopped of can it ends its
> current chunk?

Since it's blocking, I guess it's fine to wait for the current chunk
to end as long as you block. But I'm not 100% sure on that. Russell? Vinod?

> >> +         + DMA_SLAVE_CONFIG
> >> +           + Reconfigures the channel with passed configuration
> >> +           + This command should NOT perform synchronously, or on any
> >> +             currently queued transfers, but only on subsequent ones
> >> +           + In this case, the function will receive a
> >> +             dma_slave_config structure pointer as an argument, that
> >> +             will detail which configuration to use.
> >> +           + Even though that structure contains a direction field,
> >> +             this field is deprecated in favor of the direction
> >> +             argument given to the prep_* functions
> >> +         + FSLDMA_EXTERNAL_START
> >> +           + TODO: Why does that even exist?
> >> +       + The argument is an opaque unsigned long. This actually is a
> >> +         pointer to a struct dma_slave_config that should be used only
> >> +         in the DMA_SLAVE_CONFIG.
> >> +
> >> +  * device_slave_caps
> >> +    - Called through the framework by client drivers in order to have
> >> +      an idea of what are the properties of the channel allocated to
> >> +      them.
> >> +    - Such properties are the buswidth, available directions, etc.
> >> +    - Required for every generic layer doing DMA transfers, such as
> >> +      ASoC.
> >> +
> >> +Misc notes (stuff that should be documented, but don't really know
> >> +where to put them)
> >> +------------------------------------------------------------------
> >> +  * dma_run_dependencies
> >> +    - Should be called at the end of an async TX transfer, and can be
> >> +      ignored ine the slave transfers case.
> >=20
> > s/ine/in/
> >=20
> >> +    - Makes sure that dependent operations are run before marking it
> >> +      as complete.
> >> +
> >> +  * dma_cookie_t
> >> +    - it's a DMA transaction ID, that will increment over time.
> >> +    - Not really relevant anymore since the introduction of virt-dma
> >> +      that abstracts it away.
> >> +
> >> +  * DMA_CTRL_ACK
> >> +    - Undocumented feature
> >> +    - No one really has an idea of what's it's about, beside being
> >> +      related to reusing the DMA descriptors or having additional
> >> +      transactions added to it in the async-tx API
> >> +    - Useless in the case of the slave API
> >> +
> >> +General Design Notes
> >> +--------------------
> >> +
> >> +Most of the DMAEngine drivers you'll see all are based on a similar
> >> +design that handles the end of transfer interrupts in the handler, but
> >> +defer most work to a tasklet, including the start of a new transfer
> >> +whenever the previous transfer ended.
> >> +
> >> +This is a rather inefficient design though, because the inter-transfer
> >> +latency will be not only the interrupt latency, but also the
> >> +scheduling latency of the tasklet, which will leave the channel idle
> >> +in between, which will slow down the global transfer rate.
> >> +
> >> +You should avoid this kind of pratice, and instead of electing a new
> >> +transfer in your tasklet, move that part to the interrupt handler in
> >> +order to have a shorter idle window (that we can't really avoid
> >> +anyway).
> >> +
> >> +Glossary
> >> +--------
> >> +
> >> +Burst:		Usually a few contiguous bytes that will be transfered
> >> +		at once by the DMA controller
> >=20
> > A number of consecutive read or write operations that can be queued to =
buffers=20
> > before being flushed to memory.

Will change.

Thanks!

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--PEIAKu/WMn1b1Hv9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUM/4qAAoJEBx+YmzsjxAgUkAQAJ0GGMQz0VOvEkpu2TkxaGSQ
cknXf0+dlcCbDoDhLv0LBdFfSV5R16l67BLS+PWDc9gC3JLMRaDpS5trtgteGqoq
rrBwitTTuWw96YnglnGdt5Kfk1AP7u2rPbo+bwSMFamrfDHujGsgYetNK6c1Yfx4
LJyoz91vbXkNkF3+f4a8Tni/tzN6eUqd9Fk8lckR1B50KunJYntyfQo4f5Ew5q1M
noJ8lkAAX8/kBImw2XgV75abXO4P848IUzdBsOdo7VBedk9xcb1NiUQrz95ptqEH
SCy64UGusbgauV3CRmD1khml0sX+V0s6+CKobIlfHUOTLcKrw4bscU1IboDqlS5m
m4KozTKQk/TOFZU4wQmTOLxEcNkWJnl+NzIbtraxczP0bxVg9ihsTxxtGD32tPlS
PA3xD0r7F9sjBYazlvuaQ60X54WHqnsVdZXjvUEMR2MHWBduycmZ6jBlRwssER1D
rN48xFZfAFlcaaJKQ7sxoD2oHMnfnEMYAaCmNz0zZJqsFpC0wT3FwwxGZbEiq7+R
oAgKtUJJBrXvmZrr4waHKy/80OMjREDPE+ggvb0Q9tO4QCHqDJvGF75adQaDvvP8
fkgSP/0Pj4syCEJ5XznYFi82qZiARJGAv/ruobXX5nWJJgC0TwKUNAGCiWA/2A2c
dTFAhZK1WkRYsKglvIXR
=PdU+
-----END PGP SIGNATURE-----

--PEIAKu/WMn1b1Hv9--
