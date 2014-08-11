Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879AbaHKQxv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 12:53:51 -0400
Received: from mga02.intel.com ([134.134.136.20]:12059 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751512AbaHKQxu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 12:53:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,843,1400050800"; 
   d="scan'208";a="586534018"
Message-ID: <53E8F44C.7030803@linux.intel.com>
Date: Mon, 11 Aug 2014 09:50:20 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Torsten Duwe <duwe@lst.de>, Amit Shah <amit.shah@redhat.com>
CC: jgarzik@bitpay.com,
        Virtualization List <virtualization@lists.linux-foundation.org>,
        Amos Kong <akong@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
        linux-kernel@vger.kernel.org,
        Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
Subject: Re: [PATCH 1/2] rngd: add udev rule to source from hwrng if virtio-rng
 present
References: <cover.1407416628.git.amit.shah@redhat.com> <dd2ddb8458e5ab5cffceb7fac2e3f71e9e2197f3.1407416628.git.amit.shah@redhat.com> <53E3D3FF.70707@linux.intel.com> <20140808090715.GG14400@grmbl.mre> <53E54533.8030109@linux.intel.com> <20140811071527.GB4184@grmbl.mre> <20140811133030.GA27247@lst.de>
In-Reply-To: <20140811133030.GA27247@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/2014 06:30 AM, Torsten Duwe wrote:
> On Mon, Aug 11, 2014 at 12:45:27PM +0530, Amit Shah wrote:
>>
>> What's the suggested value for rng->quality, though, for virtio-rng
>> that I can use to ensure the kthread starts?
>>
>> Should I use the 700 (70%) as proposed in the original patchset?  I'm
>> not exactly sure how that value will be used as well..
> 
> There is no such thing as a suggested value, every number is wrong
> to some degree.  The quality is an estimation of how random your
> source really is; it's a property of your hardware. If the device is
> virtual you're in trouble ;-)
> 
> Either you have a way to query the underlying real hardware, or
> you do your whitening and entropy estimation in the backend driver --
> then you can claim 100%.
> 

virtio-rng I feel we could rank at 100%; it is supposed to feed
/dev/random-quality randomness from the VMM.  If the VMM is hostile you
have already lost anyway.

	-hpa

