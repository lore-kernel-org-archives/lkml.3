Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965639AbaKNPRT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 10:17:19 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:46845 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S965425AbaKNPRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 10:17:17 -0500
Date: Fri, 14 Nov 2014 10:17:16 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Benson Leung <bleung@chromium.org>
cc: johan@kernel.org, Jiri Kosina <jkosina@suse.cz>,
        <linux-usb@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sameer Nanda <snanda@chromium.org>
Subject: Re: [PATCH] HID: usbhid: get/put around clearing needs_remote_wakeup
In-Reply-To: <CANLzEksHgo_tQiwJoUtXd0iV7tDXq0ieNrAXgtXwPtxxPBWrgw@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1411141008020.1043-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Nov 2014, Benson Leung wrote:

> Hi Alan,
> 
> On Thu, Nov 13, 2014 at 2:11 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> > Wait a minute -- in your previous email you said this approach didn't
> > work.  So does it work or doesn't it?
> 
> Sorry for the confusion. The approach *does* work.
> 
> That was actually my original idea to fix the problem, but I saw other
> places in the kernel where it was done with a get/put.

The reason for the get/put is to force a call to autosuspend_check().  
But in this case, if killing the interrupt URB causes 
autosuspend_check() to run then the get/put isn't needed.

On the other hand, I don't see why killing the interrupt URB would 
cause autosuspend_check() to run.  Can you explain that?

Alan Stern



