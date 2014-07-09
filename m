Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215AbaGIODg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 10:03:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30351 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753507AbaGIODe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 10:03:34 -0400
Message-ID: <53BD4B92.7030601@redhat.com>
Date: Wed, 09 Jul 2014 16:02:58 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>,
        =?ISO-8859-1?Q?Antoine_T=E9nart?= 
	<antoine.tenart@free-electrons.com>
CC: sebastian.hesselbarth@gmail.com, kishon@ti.com,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-ide@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 3/7] ata: libahci: allow to use multiple PHYs
References: <1404728173-20263-1-git-send-email-antoine.tenart@free-electrons.com> <1404728173-20263-4-git-send-email-antoine.tenart@free-electrons.com> <20140708134000.GC4979@htj.dyndns.org> <20140708170353.GA16148@kwain> <20140708171817.GH4979@htj.dyndns.org> <20140708174900.GC16148@kwain> <20140708214010.GI4979@htj.dyndns.org> <20140709082331.GA4510@kwain> <20140709135910.GA11193@htj.dyndns.org>
In-Reply-To: <20140709135910.GA11193@htj.dyndns.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 07/09/2014 03:59 PM, Tejun Heo wrote:
> Hello,
> 
> On Wed, Jul 09, 2014 at 10:23:31AM +0200, Antoine Ténart wrote:
>>> It is confusing.  If you wanna pass around available ports in hpriv,
>>> please add a separate field and replace the arguments to
>>> save_initial_config().
>>
>> I don't get it. Which argument should I replace in
>> save_initial_config()? The change is we compute hpriv->port_map.
>> I don't see which arguments we can add or replace.
> 
> The @force_port_map and @mask_port_map of ahci_save_initial_config().
> We end up with three params from two places modifying port_map and one
> of those is in/out parameter, so ummm, no.  If you wanna add port
> masking to @hpriv, please do it by moving @force_port_map and
> @mask_port_map into @hpriv instead.
> 
> Sure, the proposed change is small but the end result is messy.
> 
>> I had a quick look on this, and it does not seems to be that simple. The
>> ahci_port_priv is stored inside the ata_port struct and not accessible
>> (as of now) from the ahci_host_priv one. The ahci_port_priv is
>> initialized at the end of ahci_platform_init_host(), far after we need
>> it. This requires quite a lot of changes. Or is there another way?
> 
> Yeah, it'd probably need separating out port resource handling, so
> that the order is get_resources, host_alloc, get_port_resources and
> then init and activate.  Hans, what do you think?

The order (and function names) you're suggesting here sound good to me.

Regards,

Hans
