Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755619AbaENPNA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 11:13:00 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42578 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752156AbaENPM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 11:12:58 -0400
Date: Wed, 14 May 2014 11:12:57 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Emil Goode <emilgoode@gmail.com>
cc: "David S. Miller" <davem@davemloft.net>, Freddy Xin <freddy@asix.com.tw>,
        Eric Dumazet <edumazet@google.com>, David Chang <dchang@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ming Lei <ming.lei@canonical.com>, Gerry Demaret <gerry@tigron.be>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        <linux-usb@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ax88179_178a: don't send commands to detached device
In-Reply-To: <1400079730-22424-1-git-send-email-emilgoode@gmail.com>
Message-ID: <Pine.LNX.4.44L0.1405141111420.1432-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 May 2014, Emil Goode wrote:

> The .stop and .unbind callbacks of struct driver_info are
> called even after a DETACH hot-plug event. In the case of
> the ax88179_178a minidriver we need to make sure we are not
> trying to send commands to a device that has been detached.
> This leads to failure messages like below.
> 
> ax88179_178a 1-1.3:1.0 (unregistered net_device):
> 	Failed to write reg index 0x0001: -19

Most driver don't bother to do this.  A few error messages in the log 
when a device gets unplugged are harmless.  Besides, this won't help 
with errors that occur between the time the device is unplugged and the 
time when the unbind callback runs.

Alan Stern

