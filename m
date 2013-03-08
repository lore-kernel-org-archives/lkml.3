Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233Ab3CHTfu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 14:35:50 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:38342 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050Ab3CHTfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 14:35:48 -0500
Date: Fri, 8 Mar 2013 11:36:24 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Samuel Iglesias =?iso-8859-1?Q?Gons=E1lvez?= 
	<siglesias@igalia.com>
Cc: industrypack-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Jens Taprogge <jens.taprogge@taprogge.org>
Subject: Re: [PATCH 1/3] ipack: avoid double free on device->id
Message-ID: <20130308193624.GD14144@kroah.com>
References: <512DCB33.6030500@igalia.com>
 <1362730907-10047-1-git-send-email-siglesias@igalia.com>
 <20130308174701.GA13276@kroah.com>
 <513A29B6.9080008@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <513A29B6.9080008@igalia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 08, 2013 at 07:11:02PM +0100, Samuel Iglesias Gonsálvez wrote:
> On 03/08/2013 06:47 PM, Greg Kroah-Hartman wrote:
> > On Fri, Mar 08, 2013 at 09:21:45AM +0100, Samuel Iglesias
> > Gonsalvez wrote:
> >> Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com> 
> >> --- drivers/ipack/ipack.c |    1 + 1 file changed, 1 
> >> insertion(+)
> >> 
> >> diff --git a/drivers/ipack/ipack.c b/drivers/ipack/ipack.c index 
> >> 7ec6b20..599d4ff 100644 --- a/drivers/ipack/ipack.c +++ 
> >> b/drivers/ipack/ipack.c @@ -24,6 +24,7 @@ static void 
> >> ipack_device_release(struct device *dev) { struct ipack_device 
> >> *device = to_ipack_dev(dev); kfree(device->id); +	device->id = 
> >> NULL;
> > 
> > How does that keep anything from being freed twice?
> > 
> >> device->release(device);
> > 
> > device should now be gone after this call, right?  What am I 
> > missing?
> > 
> 
> Yes, you are right. It's not possible to have it freed twice once it's
> in ipack_device_release().
> 
> You can skip this patch. If you want, I can resend the others accordingly.

If the others require this one to be applied, in order for them to apply
properly, yes, it would be great to resend.  If not, I'll just skip the
first one.

thanks,

greg k-h
