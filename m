Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049AbaAGPfA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 10:35:00 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:54958 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751251AbaAGPeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 10:34:50 -0500
Date: Tue, 7 Jan 2014 10:34:49 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Du, ChangbinX" <changbinx.du@intel.com>
cc: "'gregkh@linuxfoundation.org'" <gregkh@linuxfoundation.org>,
        "'sarah.a.sharp@linux.intel.com'" <sarah.a.sharp@linux.intel.com>,
        "Lan, Tianyu" <tianyu.lan@intel.com>,
        "'burzalodowa@gmail.com'" <burzalodowa@gmail.com>,
        "'linux-usb@vger.kernel.org'" <linux-usb@vger.kernel.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] usb/core: fix NULL pointer dereference in
 recursively_mark_NOTATTACHED
In-Reply-To: <0C18FE92A7765D4EB9EE5D38D86A563A01A369D2@SHSMSX103.ccr.corp.intel.com>
Message-ID: <Pine.LNX.4.44L0.1401071034300.1296-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Jan 2014, Du, ChangbinX wrote:

> > > Changbin, after looking more closely I realized there was a second
> > > aspect to this race: recursively_mark_NOTATTACHED uses hub->ports[i]
> > > while hub_disconnect removes the port devices.  You ought to be able
> > > to cause an oops by inserting a delay just after the loop where
> > > usb_hub_remove_port_device is called.
> > >
> > > The updated patch below should fix both problems.  Can you test it?
> > >
> > > Alan Stern
> > >
> > 
> > Ok, I'll test it today or tomorrow. Please wait my response.
> 
> Alan, I cannot cause a panic after inserting a delay just after 
> usb_hub_remove_port_device is called, even move the delay after 
> kfree(hub->ports). recursively_mark_NOTATTACHED will not access 
> hub->ports[i] since maxchild has been set to 0.
> 
> Alan, I think your last patch can fix this issue. 

Okay, thanks for testing.  I will submit the patch.

Alan Stern

