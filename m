Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059Ab3LRNlX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 08:41:23 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:57003 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752673Ab3LRNlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 08:41:22 -0500
Message-ID: <52B1A5FB.3030605@hurleysoftware.com>
Date: Wed, 18 Dec 2013 08:41:15 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>, linux-kernel@vger.kernel.org
CC: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v4] n_tty: Fix buffer overruns with larger-than-4k pastes
References: <52A79030.9090403@hurleysoftware.com> <1386713522-6959-1-git-send-email-peter@hurleysoftware.com> <20131217005719.GA26381@kroah.com> <52AFA7CF.3050800@hurleysoftware.com> <20131218114800.GC29631@khazad-dum.debian.net>
In-Reply-To: <20131218114800.GC29631@khazad-dum.debian.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2013 06:48 AM, Henrique de Moraes Holschuh wrote:
> On Mon, 16 Dec 2013, Peter Hurley wrote:
>>> Is this a 3.13-final thing, or can it wait for 3.14-rc1?
>>
>> Definitely not 3.13 at this point -- it should go to -next.
>
> Please earmark it for stable, if possible. This fixes a rather annoying long
> time bug, after all...

There is a (unlikely) possibility that this will cause a regression
in userspace (because this causes a successful read() to return when
it would not have in prior kernels).

I'd like to see this survive into 3.14-rc5+ before this goes to 3.12
& 3.13 -stable.

This will need multiple, different backports for pre-3.12 kernels,
which may not work correctly because pre-3.12 didn't lock out the input
processing worker during termios changes.

Regards,
Peter Hurley


