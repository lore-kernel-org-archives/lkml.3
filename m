Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759132AbaD3RPd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 13:15:33 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:36934 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752135AbaD3RPb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 13:15:31 -0400
Date: Wed, 30 Apr 2014 12:14:42 -0500
From: Felipe Balbi <balbi@ti.com>
To: Zhuang Jin Can <jin.can.zhuang@intel.com>
CC: Felipe Balbi <balbi@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: dwc3: debugfs: add snapshot to dump requests trbs
 events
Message-ID: <20140430171442.GR23679@saruman.home>
Reply-To: <balbi@ti.com>
References: <20140428204923.GC12185@intel.com>
 <20140428155536.GE30292@saruman.home>
 <20140429212142.GA25710@intel.com>
 <20140429161042.GD633@saruman.home>
 <20140501050625.GA20672@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xSu31lw3TgkWXnjh"
Content-Disposition: inline
In-Reply-To: <20140501050625.GA20672@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--xSu31lw3TgkWXnjh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, May 01, 2014 at 01:06:25AM -0400, Zhuang Jin Can wrote:
> Hi,
>=20
> On Tue, Apr 29, 2014 at 11:10:42AM -0500, Felipe Balbi wrote:
> > Hi,
> >=20
> > On Tue, Apr 29, 2014 at 05:21:42PM -0400, Zhuang Jin Can wrote:
> > > On Mon, Apr 28, 2014 at 10:55:36AM -0500, Felipe Balbi wrote:
> > > > On Mon, Apr 28, 2014 at 04:49:23PM -0400, Zhuang Jin Can wrote:
> > > > > Adds a debugfs file "snapshot" to dump dwc3 requests, trbs and ev=
ents.
> > > >=20
> > > > you need to explain what are you trying to provide to our users her=
e.
> > > >=20
> > > > What "problem" are you trying to solve ?
> > > >=20
> > > The interface enables users to easily peek into requests, trbs and
> > > events to know the current transfer state of each request.
> > > If an transfer is stuck, user can use the interface to check why it's
> > > stuck (e.g. Is it because a gadget doesn't queued the request? Or it's
> > > queued but it's not primed to the controller? Or It's primed to the
> > > controller but the TRBs and events indicate the transfer never comple=
tes?).
> > > User can immediately narrow down the issue without enabling verbose l=
og or
> > > reproduce the issue again. It's helpful when we need to deal with some
> > > hard-to-reproduce bugs or timing sensitive bugs can't be reproduced w=
ith
> > > verbose log enabled.
> >=20
> > this should be part of the commit log in some shape or form.
> >=20
> Yes.
>=20
> > > > > As ep0 requests are more complex than others. It's not included i=
n this
> > > > > patch.
> > > >=20
> > > > For ep0, you could at least print the endpoint phase we are current=
ly
> > > > in and if we have requests in flight or not.
> > > >=20
> > > Agree. Will add it in [PATCH v2].
> >=20
> > tks
> >=20
> > > > > +			seq_puts(s, "busy_slot--|\n");
> > > > > +			seq_puts(s, "           \\\n");
> > > > > +		}
> > > > > +		if (i =3D=3D (dep->free_slot & DWC3_TRB_MASK)) {
> > > > > +			seq_puts(s, "free_slot--|\n");
> > > > > +			seq_puts(s, "           \\\n");
> > > > > +		}
> > > > > +		seq_printf(s, "trb[%02d](dma@0x%pad): %08x(bpl), %08x(bph), %0=
8x(size), %08x(ctrl)\n",
> > > >=20
> > > > I'm not sure you need to print out the TRB address. bpl, bph, size =
and
> > > > ctrl are desired though.
> > > >=20
> > > printing out the TRB DMA address helps user to locate the start TRB o=
f a
> > > request. I admit that we can achive the same purose using the "start_=
slot"
> > > of the request. I'll remove it in [PATCH v2].
> >=20
> > thanks
> >=20
> > > > > +			i, &dep->trb_pool_dma + i * sizeof(*trb),
> > > > > +			trb->bpl, trb->bph, trb->size, trb->ctrl);
> > > >=20
> > > > this will be pretty difficult to parse by a human. I would rather s=
ee
> > > > you creating one directory per TRB (and also one directory per
> > > > endpoint) which holds the details for that entity, so that it looks
> > > > like:
> > > >=20
> > > > dwc3
> > > > |-- current_state	(or perhaps a better name, but snapshot isn't ver=
y good either)
> > > Actually, it's hard to find a perfect name. "current_state" or "snaps=
hot" doesn't
> > > make too much difference to me. If "current_state" makes more sense t=
o you, I
> > > can change to use this name. Or let me know if you have a better sugg=
estion.
> >=20
> > the name is important as we will have to deal with it for the next 50
> > years. We also need to think about someone starting out on dwc3 5 years
> > from now or a QA engineer in whatever OEM trying to provide details of
> > the failure for the development team. It needs to be well thought out.
> >=20
> > I don't have a better idea but snapshot gives me the idea that we will
> > end up with a copy of everything which we can revisit at any time and
> > that's not true. If we read this file twice there's no guarantee it'll
> > contain the same information.
> >=20
> Let's discuss the name later after I explain more about the motivation.
>=20
> [Motivation]
> The patch is inspired from echi-dbg.c debugfs. It contains four files
> "async", ""bandwidth", "periodic" and "registers".
> The "registers" functions as what "regdump" does in dwc3. And the patch i=
mplements
> a "snapshot" to do the similar things done by "async" and "periodic".
> Because a way to inspect the content of data structures (i.e. TRBs, Event=
s)
> interacting with the controller is really important for debugging,
> especially for HW issues. It just simply provides you a interface to check
> what's currently in TRBs and event buffers (and nothing more, no more
> guarantees).=20
> In EHCI, "async" and "periodic" also can't guarantee you the reliable dat=
a, as
> you can't prevent the controller from writing the interacting data
> structures (unless you stop it). It's developer's decision to how to anal=
yze
> the data. They're not perfect, but simple and helpful.
>=20
> As far as I see, it's useful for below senarios:
> 1. Bugs can't be reproduced with VERBOSE_DEBUG, as printk introduces
> timing effect. Some HW bugs are timing sensitive, even a single printk
> will prevent you from reproducing the issue.
> With "snapshot", we can check the TRBs, events, requests to see the
> final status to get more clues to triage an issue.
>=20
> 2. Some bugs are hard to reproduce, and can be seen once or
> twice after many devices running for a long time. (e.g. MTBF runing with
> ADB). And they most often uses the builds with debugfs available, ask
> them to turn on VERBOSE_DEBUG and run the tests are not acceptable.
> After the failure happens, if you ask the tester to turn on the VERBOSE_D=
EBUG
> to reproduce the issue again. He may come back to you a week later with
> an answer "I can't reproduce it. It's a random issue".=20
> With "snapshot", when the issue happens, tester can just dump the TRBs,
> events to provide more data to a developer. It won't guarantee you to
> root cause the issue, but something is better than nothing.
>=20
> Regarding what are important to dump, regarding the motivation, they shou=
ld be
> TRBs and Events which are the parts interfacing with HW. But only dumping=
 them is
> not enough, it's useless if user can't tell which TRB belongs to which
> endpont and request. That's why I also dump the necessary info about the
> requests and endpoints to track their relationship. Infos like maxpacket
> size, direction, types are not really important regarding this. You can
> get the information by running it once and see the printks. And they're
> common properties which can just be handed off to udc core.
>=20
> > > >     |-- ep2
> > > >     |   |-- direction
> > > >     |   |-- maxpacket
> > > >     |   |-- number
> > > >     |   |-- state
> > > >     |   |-- stream_capable
> > > >     |   |-- type
> > > >     |   |-- trbs
> > > >     |   |   |-- trb0
> > > >     |   |   |   |-- bph
> > > >     |   |   |   |-- bpl
> > > >     |   |   |   |-- ctrl
> > > >     |   |   |   |-- size
> > > >     |   |   |-- trb1
> > > >     |   |   |   |-- bph
> > > >     |   |   |   |-- bpl
> > > >     |   |   |   |-- ctrl
> > > >     |   |   |   |-- size
> > > >     |   |   |-- trb2
> > > >     |   |   |   |-- bph
> > > >     |   |   |   |-- bpl
> > > >     |   |   |   |-- ctrl
> > > >     |   |   |   |-- size
> > > >     |   |   |-- trb3
> > > >     |   |   |   |-- bph
> > > >     |   |   |   |-- bpl
> > > >     |   |   |   |-- ctrl
> > > >     |   |   |   |-- size
> > > >     .   .   .
> > > >     .   .   .
> > > >     .   .   .
> > > >     |   |-- request0
> > > >     |   |   |-- direction
> > > >     |   |   |-- mapped
> > > >     |   |   |-- queued
> > > >     |   |   |-- trb0	(symlink to actual trb directory)
> > > >     |   |   |-- ep2		(symlink to actual ep2 directory)
> > > >     |   |   |-- usbrequest
> > > >     |   |       |-- actual
> > > >     |   |       |-- length
> > > >     |   |       |-- no_interrupt
> > > >     |   |       |-- num_mapped_sgs
> > > >     |   |       |-- num_sgs
> > > >     |   |       |-- short_not_ok
> > > >     |   |       |-- status
> > > >     |   |       |-- stream_id
> > > >     |   |       |-- zero
> > > >     |   |-- request1
> > > >     |   |   |-- direction
> > > >     |   |   |-- mapped
> > > >     |   |   |-- queued
> > > >     |   |   |-- trb1	(symlink to actual trb directory)
> > > >     |   |   |-- ep2		(symlink to actual ep2 directory)
> > > >     |   |   |-- usbrequest
> > > >     |   |       |-- actual
> > > >     |   |       |-- length
> > > >     |   |       |-- no_interrupt
> > > >     |   |       |-- num_mapped_sgs
> > > >     |   |       |-- num_sgs
> > > >     |   |       |-- short_not_ok
> > > >     |   |       |-- status
> > > >     |   |       |-- stream_id
> > > >     |   |       |-- zero
> > > >     .   .   .   .
> > > >     .   .   .   .
> > > >     .   .   .   .
> > > >=20
> > > >=20
> > > > and so forth. That way we get a structured view of everything the
> > > > controller and the driver are managing.
> > > >=20
> > > The patch intends to dump the most important RUNTIME information the =
driver is
> > > dealing with the controller, STATIC information is not valuable here =
as we can
> > > get them before running. I consider information like "direction", "ma=
xpactsize",
> > > "types" are STATIC, as they're not going to change once they are conf=
igured.
> >=20
> > they are still important and easy enough to print out. Sometimes
> > direction is the key information for a debug session. For example if a
> > Bulk OUT transaction of length 2000 never completes we *know* the reason
> > why.
> >=20
> > We know OUT endpoints can't handle transfers which are not aligned to
> > wMaxPacketSize.
> >=20
> Explained in [Motivation], these info can be got by VERBOSE_DEBUG by runn=
ing it once.
> It's not the "snapshot" really want to handle.
>=20
> > > Dumping everying is not the intention of the patch. (Sorry that the n=
ame
> >=20
> > so ? I'm making a suggestion to improve the patch. Dumping only the
> > information you judged necessary during your debug sessions with no
> > consideration for other users isn't generally a good practice. I'm
> > trying to help you improve the patch so that it can be accepted.
> >=20
> > Note that dumping all of that information out of a single file isn't
> > very nice either and it'll be difficult to parse, even for humans.
> >=20
> Explained in [Motivation].
>=20
> > > So are you suggesting to organize the information in multiple debugfs
> > > directories and files or just to print information with appropriate i=
ndents so that
> >=20
> > multiple directories.
> >=20
> Explained in [Motivation]. echi-dbg.c also uses a single file to dump the
> structures. But I admit that dumping event buffers can be in a separate f=
ile.
>=20
> > > users can easily read it? IMO, organizing them in multiple files makes
> > > it impossible for the user to lock dwc3->lock and get information
> > > atomically. The problem of reading them separately is that it won't g=
ive
> > > you the consistent information regarding the current transfer state.
> >=20
> > it depends on where you hold the lock. Also, now that I think of it, it
> > really seems like what you want is tracepoints on this driver, rather
> > than dumping a whole bunch of information out of a single read to a
> > single file. The kernel has a very nice tracing infrastructure and I'd
> > be really happy to read a patch adding support for that in this driver.
> >=20
> Explained in [Motivation], I'm sorry that I have no experience of using
> tracepoint:(, so I googled it, and found that I can't use them to
> achieve the same purpose as "snapshot". But I maybe wrong.
>=20
> > > > > +static void dwc3_dump_dev_event(struct seq_file *s,
> > > > > +			const struct dwc3_event_devt *event)
> > > > > +{
> > > > > +	seq_puts(s, "[0]DEV ");
> > > > > +	seq_printf(s, "[1:7]%s ",
> > > > > +		event->device_event =3D=3D DWC3_EVENT_TYPE_DEV ? "TYPE_DEV" :
> > > > > +		event->device_event =3D=3D DWC3_EVENT_TYPE_CARKIT ? "TYPE_CARK=
IT" :
> > > > > +		event->device_event =3D=3D DWC3_EVENT_TYPE_I2C ? "TYPE_CARKIT"=
 :
> > > > > +		"TYPE_UNKOWN");
> > > > > +	seq_printf(s, "[8:11]%s ", dwc3_gadget_event_string(event->type=
));
> > > > > +
> > > > > +	if (event->type =3D=3D DWC3_DEVICE_EVENT_LINK_STATUS_CHANGE ||
> > > > > +		event->type =3D=3D DWC3_DEVICE_EVENT_HIBER_REQ) {
> > > > > +
> > > > > +		seq_printf(s, "[16:20]%s %s ",
> > > > > +			dwc3_link_state_string(
> > > > > +				event->event_info & DEVT_EVTINFO_SUPERSPEED,
> > > > > +				event->event_info & DWC3_LINK_STATE_MASK),
> > > > > +				event->event_info & DEVT_EVTINFO_SUPERSPEED ?
> > > > > +				"SS" : "HS");
> > > > > +
> > > > > +		if (!(event->event_info & DEVT_EVTINFO_SUPERSPEED))
> > > > > +			seq_printf(s, "[21:24]HIRD %u ",
> > > > > +				DEVT_EVTINFO_HIRD(event->event_info));
> > > > > +	}
> > > > > +}
> > > > > +
> > > > > +static void dwc3_dump_ep_event(struct seq_file *s,
> > > > > +			const struct dwc3_event_depevt *event)
> > > > > +{
> > > > > +	seq_puts(s, "[0]EP ");
> > > > > +	seq_printf(s, "[1:5]ep%d ", event->endpoint_number);
> > > > > +	seq_printf(s, "[6:9]%s ",
> > > > > +		dwc3_ep_event_string(event->endpoint_event));
> > > > > +
> > > > > +	switch (event->endpoint_event) {
> > > > > +	case DWC3_DEPEVT_XFERCOMPLETE:
> > > > > +	case DWC3_DEPEVT_XFERINPROGRESS:
> > > > > +		if (event->status & DEPEVT_STATUS_BUSERR)
> > > > > +			seq_puts(s, "[12]BUSERR ");
> > > > > +		if (event->status & DEPEVT_STATUS_SHORT)
> > > > > +			seq_puts(s, "[13]SHORT ");
> > > > > +		if (event->status & DEPEVT_STATUS_IOC)
> > > > > +			seq_puts(s, "[14]IOC ");
> > > > > +		if (event->status & DEPEVT_STATUS_LST)
> > > > > +			seq_puts(s, "[15]LST ");
> > > > > +		break;
> > > > > +	case DWC3_DEPEVT_XFERNOTREADY:
> > > > > +		if ((event->status & 0x3) =3D=3D 1)
> > > > > +			seq_puts(s, "[12:13]Data_Stage ");
> > > > > +		else if ((event->status & 0x3) =3D=3D 2)
> > > > > +			seq_puts(s, "[12:13]Status_Stage ");
> > > > > +		if (event->status & DEPEVT_STATUS_TRANSFER_ACTIVE)
> > > > > +			seq_puts(s, "[15]XferActive ");
> > > > > +		else
> > > > > +			seq_puts(s, "[15]XferNotActive ");
> > > > > +		break;
> > > > > +	case DWC3_DEPEVT_EPCMDCMPLT:
> > > > > +		if (event->status & BIT(0))
> > > > > +			seq_puts(s, "[12:15]Invalid Transfer Resource ");
> > > > > +		break;
> > > > > +	default:
> > > > > +		seq_puts(s, "[12:15]UNKOWN ");
> > > > > +	}
> > > > > +	seq_printf(s, "[16:31]PARAM 0x%04x ", event->parameters);
> > > > > +}
> > > > > +
> > > > > +static void dwc3_dump_event_buf(struct seq_file *s,
> > > > > +			struct dwc3_event_buffer *evt)
> > > > > +{
> > > > > +	union dwc3_event	event;
> > > > > +	int			i;
> > > > > +
> > > > > +	seq_printf(s, "evt->buf@0x%p(dma@0x%pad), length=3D%u, lpos=3D%=
u, count=3D%u, flags=3D%s\n",
> > > > > +		evt->buf, &evt->dma,
> > > > > +		evt->length, evt->lpos, evt->count,
> > > > > +		evt->flags & DWC3_EVENT_PENDING ? "pending" : "0");
> > > > > +
> > > > > +	for (i =3D 0; i < evt->length; i +=3D 4) {
> > > > > +		event.raw =3D *(u32 *) (evt->buf + i);
> > > > > +		if (i =3D=3D evt->lpos) {
> > > > > +			seq_puts(s, "lpos-------|\n");
> > > > > +			seq_puts(s, "           \\\n");
> > > > > +		}
> > > > > +		seq_printf(s, "event[%d]: %08x ", i, event.raw);
> > > > > +
> > > > > +		if (event.type.is_devspec)
> > > > > +			dwc3_dump_dev_event(s, &event.devt);
> > > > > +		else
> > > > > +			dwc3_dump_ep_event(s, &event.depevt);
> > > > > +		seq_puts(s, "\n");
> > > > > +	}
> > > >=20
> > > > how well have you tested this ? I'm not entirely sure you should be
> > > > reading the event buffer at any time you want, though I might be wr=
ong.
> > > >=20
> > > > It's still a bit easier to reproduce part of the event handling her=
e. I
> > > > think it's best to make a choice of caching the last 5 events in a =
ring
> > > > buffer and provide a helper for IRQ handlers to push events into the
> > > > ring buffer, then from here you just iterate over that ring buffer
> > > > instead of accessing our actual event buffer.
> > > >=20
> > > Thanks Paul Zimmerman and you for reminding me that fact that control=
ler
> > > may write to the event buffers when we're reading them.
> > >=20
> > > Instead of trying to make things perfect and complex, the interface i=
s just
> > > to dump the events while leaving the responsibilty to developers to j=
udge
> > > if the events are reliable.
> >=20
> > That's a crappy interface then. Why would anybody use anything they
> > can't trust ?
> >=20
> Explained in [Motivation]. Simply treat it as an interface just dumping t=
he
> structures.
>=20
> > > Developer should be able to sense if the data is reliable depending o=
n when he
> > > dumps the data. If a transfer is stuck and controller doesn't generat=
e anymore
> >=20
> > or Developer might spend more time looking at somehting that doesn't
> > make sense and trying to figure out if the current trace is valid then
> > the time spent actually understanding the problem.
> >=20
> > Logs are suppose to aid debugging and if the data isn't trustworthy we
> > will have developers spending time debugging the logs themselves. Sorry,
> > but I won't accept that.
> >=20
> Explained in [Motivation]. Something is better than nothing. Debugging
> is not just about looking at the data and "Oh, here it is". Analyze the
> data. It's developer's responsibilty to check how the data is correlated
> with a specific failure.
>=20
> > > events, then the data is reliable, and this is the main senario this =
patch wants
> > > to handle. If a transfer is stuck but controller keeps generating eve=
nts due to
> >=20
> > that you already get with Verbose debug anyway and you get *all* that
> > data with a simple dmesg.
> >=20
> Explained in [Motivation], verbose debug has its limitations.
>=20
> > > other transfers, there's nothing we can do about it, as the new event=
s will
> > > quickly overwrite the ring, and developer will know the events are no=
t valuable.
> >=20
> > and there goes a debug session down the drain, it turned out to be a
> > waste of time after all.
> >=20
> > > If you dump the events when all transfers are still on-going, it just=
 provides
> > > you some a history of the events to sense how it looks like, and you
> > > know the data might not be reliable. And this usage is not really hel=
pful
> > > for debugging or not used at all, as you should have no intereset to
> > > check the events if everythings goes well.
> > > I think above is acceptable for debugging purpose, it's simple without
> > > introducing any overhead or timing effect.
> >=20
> > wait, what ? everytime you read that file you hold the controller lock
> > god knows for how long and you say it doesn't introduce any timing
> > effect ?
> >=20
> > Verbose logs have a lower overhead than what you're suggesting here.
> >=20
> If the test doesn't fail, you should have no interest to read the file.
> So no overhead during running.
> After the failure, you can read the file, the overhead is not a big deal
> at this point.
>=20
> > > > Also note that we can hold up to 64 events in our event buffer so t=
his
> > > > call could take a looooooot of time to complete and you probably do=
n't
> > > > need all that information anyway because you can get them by just
> > > > enabling VERBOSE_DEBUG on dwc3 and capturing the entire driver beha=
vior
> > > > on dmesg.
> > > >=20
> > > Even though a user may be scared by the lots of events, when a failur=
e happens,
> > > he actually wants to read as many events as he can to see what happen=
ed
> > > before the failure. 5 events is not enough, user can at most only see=
 one
> > > or two transfers through these 5 events or nothing if the last few
> > > events are generated from other transfers which are unrelated to the
> > > failure. The time to dump the events doesn't matter as it's for debug=
ging and
> > > most often usage is after a transfer is stuck.
> >=20
> > right, so if the transfer is stuch there are no extra generated anyway.
> >=20
> > And I continue to say that all of this information is already available
> > by enabling VERBOSE_DEBUG for this driver.
> >=20
> > If you want to capture logs without VERBOSE_DEBUG tracepoints sound like
> > the way to go.
> >=20
> Explained in [Motivation], I'm not trying to capture logs without
> VERBOSE_DEBUG.

since you're just giving me a bunch of excuses to not modify your patch
which, well, was written for your own use case then I'll just ignore
this patch altogether.

When I get time, I'll add proper tracepoints to this driver which will
help many other engineers in many other use cases, not just one.

sorry but your patch is not good for acceptance in mainline.

--=20
balbi

--xSu31lw3TgkWXnjh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTYS+CAAoJEIaOsuA1yqREzYEQAIsdVgveogu0ewKjmRzMqrMz
2TFY7t5DmW5g+c/oUXJAtH+ZomIPyPIZwEcCC9jyKmUmdc188IPZZfPE9duMGXQO
qONML1R8oQzrN0GRbT1rpZtIclw+6xs6221S1JoDdNJ+qBR0uFkROYmK6z7ZjdHz
8yb74XDsdlfzcoGjXzWCrGiWnjuDmgkU/tLUETPbiosXrdTW5zEaC/xzGmQ9/R94
wOc0tXEEmBKuuMHMe2iSGDN2yYdXPck5VyP8nEFxqFY7l0cZ7MIoBe3xAYJYT9EZ
46OV8K6NjGLKjXotMSLvHOM28C+5x9034gTP1Is+5kSEFhrupo8wEVTE7jAK1VNh
ykuHcSbdnEWkpLHfjfPHtI4dJg7ZC3Di0+G19x6DDOEGXUY81AOVxRPui1yoog0i
Ucpar6lzL16lS3oen0mi99Aew73cMsipR6kiUsNK7suX56AvXnsObhwPG6RsjEtb
0pACXBQUH0htWOPA0MGL7QxSHtDsEbYQQ9Wsd9AmoEA2FBEprN6IbTAOvODuFstA
0yjz5ESS1f4epJUQKNRtgUklWCcUX3niyZBq5mIQLv/Af64omGyoY6aPS93owJav
Gfu7gFQiGnv6cx6Mu4vckSVIPABxpO6O7PeutoMynEeYZSyw3EXGoP0YdaBMePK0
uDPiQ2AbJsnm3pgM6Uu3
=1Rzw
-----END PGP SIGNATURE-----

--xSu31lw3TgkWXnjh--
