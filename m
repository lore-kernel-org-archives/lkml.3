Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498AbaC0C1U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 22:27:20 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:42589 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751240AbaC0C1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 22:27:18 -0400
Message-ID: <53338C81.3060600@hurleysoftware.com>
Date: Wed, 26 Mar 2014 22:27:13 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: balbi@ti.com
CC: Tony Lindgren <tony@atomide.com>, Greg KH <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        m-karicheri2@ti.com, b32955@freescale.com,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 10/11] Revert "serial: omap: unlock the port lock"
References: <1395343807-21618-1-git-send-email-balbi@ti.com> <1395343807-21618-10-git-send-email-balbi@ti.com> <20140325182856.GA31906@atomide.com> <5333732F.6040803@hurleysoftware.com> <20140327021043.GB11651@saruman.home>
In-Reply-To: <20140327021043.GB11651@saruman.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26/2014 10:10 PM, Felipe Balbi wrote:
> Hi,
>
> On Wed, Mar 26, 2014 at 08:39:11PM -0400, Peter Hurley wrote:
>> On 03/25/2014 02:28 PM, Tony Lindgren wrote:
>>> * Felipe Balbi <balbi@ti.com> [140320 12:39]:
>>>> This reverts commit 0324a821029e1f54e7a7f8fed48693cfce42dc0e.
>>>>
>>>> That commit tried to fix a deadlock problem when using
>>>> hci_ldisc, but it turns out the bug was in hci_ldsic
>>>> all along where it was calling ->write() from within
>>>> ->write_wakeup() callback.
>>>>
>>>> The problem is that ->write_wakeup() was called with
>>>> port lock held and ->write() tried to grab the same
>>>> port lock.
>>>
>>> Should this and the next patch be earlier in the series
>>> as a fix for the v3.15-rc cycle? Should they be cc: stable
>>> as well?
>>
>> Well, right now the other fix has had _zero_ testing
>> so not really a -stable candidate just yet.
>
> how can you even say that ?

I misunderstood when you wrote:

On 03/20/2014 02:11 PM, Felipe Balbi wrote:
 > here's a build-tested only patch which is waiting for testing from other
 > colleagues who've got a platform to reproduce the problem:

and then the version I reviewed had no Tested-by: tags.

> Unless you work for some 3 letter acronym
> organizations, you have no clue about the fact that this was tested on a
> keystone 2 platform.

Ok.

> How else would we have found the issue to start with ?

Bug report?

Regards,
Peter Hurley

