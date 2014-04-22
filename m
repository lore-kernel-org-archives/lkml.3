Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871AbaDVN5b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 09:57:31 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42502 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751180AbaDVN51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 09:57:27 -0400
Date: Tue, 22 Apr 2014 09:57:26 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: sundeep subbaraya <sundeep.lkml@gmail.com>
cc: Felipe Balbi <balbi@ti.com>,
        Subbaraya Sundeep Bhatta <subbaraya.sundeep.bhatta@xilinx.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michal Simek <michals@xilinx.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Subbaraya Sundeep Bhatta <sbhatta@xilinx.com>
Subject: Re: [PATCH v2 2/2] usb: gadget: Add xilinx axi usb2 device support
In-Reply-To: <CALHRZur7+MaYXbWOfbvjggPN7_eYAE+th5VNbcLP=ehvm0HGsA@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1404220956210.1326-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Apr 2014, sundeep subbaraya wrote:

> Hi,
> 
> On Mon, Apr 21, 2014 at 10:09 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> > On Mon, 21 Apr 2014, Felipe Balbi wrote:
> >
> >> Hi,
> >>
> >> On Fri, Apr 18, 2014 at 07:34:08PM +0530, sundeep subbaraya wrote:
> >>
> >> <snip>
> >>
> >> > >> in ep_queue driver starts dma transfer from/to IP buffer to/from req->buf.
> >> > >> If transfer is completed then request is not added to ep request queue
> >> > >> and returns from ep_queue.
> >> > >> If transfer is not completed (actual < length) then request is added
> >> > >> to queue and returns from ep_queue.
> >> > >
> >> > > This is wrong. Why wouldn't you give gadget driver the chance to decide
> >> > > if it needs to queue the request again or not ?
> >> >
> >> > When does gadget driver decides to queue the same request again?
> >> > if -EBUSY is returned from ep_queue or req.status != 0 in completion
> >> > routine?
> >>
> >> whenever it so decides. Different gadget drivers might have different
> >> requirements. The code is open and sits under drivers/usb/gadget/ why
> >> don't you have a read ?
> >
> > I get the impression that the two of you are arguing past each other.
> > It appears that Sundeep is talking about transferring data from the
> > gadget driver's buffer to an internal buffer in the UDC hardware, but
> > Felipe is talking about transferring data from the UDC to the host.
> >
> > As I understand it, Sundeep said that when the gadget driver queues a
> > data-IN request, the UDC driver copies as much of the data buffer as
> > possible into a hardware FIFO.  If it succeeds in copying all the data
> > into the FIFO then the request's completion routine gets called
> > immediately, even though the data doesn't get sent from the FIFO to the
> > host until the host asks for it.
> >
> > If only part of the data can be copied into the FIFO then the request
> > is added to the ep's request queue before the usb_ep_queue() call
> > returns.  When space becomes available in the FIFO, the data will be
> > copied and eventually sent to the host.  When all the data has been
> > copied to the FIFO, the request's completion routine will be called.
> >
> > Thus there never is any need for the gadget driver to queue the request
> > again.  An incomplete transfer means the FIFO didn't have enough room
> > when the request was submitted; it doesn't mean that the data didn't
> > eventually get sent to the host.
> 
> Exactly Alan,this is what I was trying to say. Probably I was not
> clear in explaining. I didnt see
> any harm this way and even this implementation is same like
> at91_udc.c. I have been reading
> mas_storage to understand when does gadget driver tries to enqueue a
> request again. Since
> different gadget drivers might have different requirements (agree with
> Felipe), wanted to
> know criteria for queuing a same request again.
> 
> I will change this implementation as per Felipe comments and test with
> some of the gadgets.

Wait until you hear what Felipe has to say about this discussion.  
Maybe he will decide that the original implementation was correct.

Alan Stern

