Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836Ab3LJO0J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 09:26:09 -0500
Received: from collab.rosalab.ru ([195.19.76.181]:42412 "EHLO
	collab.rosalab.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523Ab3LJO0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 09:26:07 -0500
Message-ID: <52A72466.8050606@rosalab.ru>
Date: Tue, 10 Dec 2013 18:25:42 +0400
From: Eugene Shatokhin <eugene.shatokhin@rosalab.ru>
Organization: ROSA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Daniel Vetter <daniel@ffwll.ch>
CC: intel-gfx@lists.freedesktop.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: i915: NULL pointer dereference in i915_update_dri1_breadcrumb()
 during shutdown
References: <52A6D08B.1040802@rosalab.ru> <20131210122351.GF9804@phenom.ffwll.local>
In-Reply-To: <20131210122351.GF9804@phenom.ffwll.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2013 04:23 PM, Daniel Vetter wrote:
> On Tue, Dec 10, 2013 at 12:27:55PM +0400, Eugene Shatokhin wrote:
>> Hi,
>>
>> I have recently observed a NULL pointer dereference in i915 driver
>> on my Eee PC running ROSA Linux with kernel 3.10.21.
>>
>> The crash occurs during shutdown but quite rarely, not each time.
>>
>> The system log is lost but here is what I extracted from the info
>> displayed on the screen.
>>
>> NULL pointer dereference at 0x4
>> EIP is at i915_update_dri1_breadcrumb+0x25/0x70
>> comm: systemd-journal
>>
>> i915_update_dri1_breadcrumb+0x25:
>> 	mov    0x4(%eax),%ebx // %eax contains 0, the list of register
>> values confirms that.
>>
>> That is the reading of 'master_priv->sarea_priv':
>>
>> void i915_update_dri1_breadcrumb(struct drm_device *dev)
>> {
>> 	drm_i915_private_t *dev_priv = dev->dev_private;
>> 	struct drm_i915_master_private *master_priv;
>>
>> 	if (dev->primary->master) {
>> 		master_priv = dev->primary->master->driver_priv;
>> 		if (master_priv->sarea_priv) // <<< crashes here
>> 			master_priv->sarea_priv->last_dispatch =
>> 				READ_BREADCRUMB(dev_priv);
>> 	}
>> }
>
> Indeed, that's fairly hapzardous. But also only needed for legacy ums
> support. I'll send out a patch to block this in kms mode quickly. Please
> test it.
>
> Thanks, Daniel

Thanks a lot!

I am building kernel 3.10.23 now with this patch applied and will let 
you know if something goes wrong.

Regards,
Eugene

-- 
Eugene Shatokhin, ROSA Laboratory.
www.rosalab.com
