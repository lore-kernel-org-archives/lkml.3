Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751709AbaAQAfi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 19:35:38 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:57609 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbaAQAfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 19:35:36 -0500
Date: Thu, 16 Jan 2014 16:35:31 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Christopher Heiny <cheiny@synaptics.com>
Cc: Andrew Duggan <aduggan@synaptics.com>,
        Vincent Huang <vincent.huang@tw.synaptics.com>,
        Vivian Ly <vly@synaptics.com>,
        Daniel Rosenberg <daniel.rosenberg@synaptics.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Linux Input <linux-input@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] Input: synaptics-rmi4 - switch to using
 i2c_transfer()
Message-ID: <20140117003531.GE837@core.coreip.homeip.net>
References: <1389339867-8399-1-git-send-email-dmitry.torokhov@gmail.com>
 <1389339867-8399-4-git-send-email-dmitry.torokhov@gmail.com>
 <52D4F4C7.8000706@synaptics.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52D4F4C7.8000706@synaptics.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 12:26:47AM -0800, Christopher Heiny wrote:
> On 01/09/2014 11:44 PM, Dmitry Torokhov wrote:
> >
> >-	dev_dbg(&client->dev, "writes 1 bytes: %02x\n", txbuf[0]);
> >+	retval = i2c_transfer(client->adapter, msgs, sizeof(msgs));
> >+	if (retval == sizeof(msgs))
> 
> I think this should be:
> 	retval = i2c_transfer(client->adapter, msgs, ARRAY_SIZE(msgs));
> 	if (retval == ARRAY_SIZE(msgs))
> At least, that change resolved some random misbehaviors, including
> kernel panics.

You are absolutely right, I just committed a fix for that.

Thanks.

-- 
Dmitry
