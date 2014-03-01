Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735AbaCAMqX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 07:46:23 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:20130 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318AbaCAMqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 07:46:22 -0500
Date: Sat, 1 Mar 2014 15:44:18 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Chase Southwood <chase.southwood@yahoo.com>
Cc: gregkh@linuxfoundation.org, abbotti@mev.co.uk,
        hsweeten@visionengravers.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Staging: comedi: introduce outl_1564_* and
 inl_1564_* helper functions in hwdrv_apci1564.c
Message-ID: <20140301124418.GT26776@mwanda>
References: <1393572680-9521-1-git-send-email-chase.southwood@yahoo.com>
 <1393669707-20107-1-git-send-email-chase.southwood@yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393669707-20107-1-git-send-email-chase.southwood@yahoo.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 01, 2014 at 04:28:27AM -0600, Chase Southwood wrote:
> This patch introduces a handful of outl and inl helper functions with the
> ultimate goal of improving code readability and allowing several lines
> which violate the character limit to be shortened in a sane way.
> 
> Cc: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
> ---
> This patchset serves as a replacement to my previous cleanup patchset for
> hwdrv_apci1564.c
> 
> Dan,
> After spending a little bit more time with this and trying out different
> ways of cleaning this up, I decided that making helper functions for all
> of the most common register sets would look the best, but I haven't made
> a helper for a few of the least common inl/outl calls because if I did,
> the sheer number of helper functions would get quite ridiculous.
> Let me know if you think my selections of what to make into helper
> functions seems appropriate.
> 

Yeah.  You're right...  It's kind of a lot of helper functions.

I wonder if we could just do something like:

static void outl_amcc(struct addi_private *devpriv, unsigned int cmd,
		      unsigned int reg)
{
	outl(cmd, devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP + reg);
}

And then change APCI1564_DIGITAL_IP_INTERRUPT_MODE1 to be:

#define APCI1564_DIGITAL_IP_INTERRUPT_MODE1 (0x4 + 0x4)

The only problem with that would be i_APCI1564_Reset().  Is
i_APCI1564_Reset() buggy?  Ian or Hartley might know.  Take a look at
other comedi drivers as well to see what they do.

regards,
dan carpenter

