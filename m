Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880AbaHKOGw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 10:06:52 -0400
Received: from mail.active-venture.com ([67.228.131.205]:62741 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753668AbaHKOGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 10:06:51 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53E8CDF8.2060008@roeck-us.net>
Date: Mon, 11 Aug 2014 07:06:48 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm: Do not use BUG_ON(!spin_is_locked())
References: <1407731491-22446-1-git-send-email-linux@roeck-us.net> <alpine.DEB.2.02.1408110439580.15519@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1408110439580.15519@chino.kir.corp.google.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/2014 04:45 AM, David Rientjes wrote:
> On Sun, 10 Aug 2014, Guenter Roeck wrote:
>
>> spin_is_locked() always returns false in uniprocessor configurations
>> and can therefore not be used with BUG_ON. Replace it with
>> assert_spin_locked(), which exists for that very purpose.
>>
>
> It may be helpful to assess whether any of these sites should be converted
> to lockdep_assert_held() so they have no cost when lockdep isn't enabled
> but still reveal problems when debugging.
>
>

Possibly, but that would need to be done by someone with better knowledge
about locking and the code than me.

Guenter

