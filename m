Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752401AbaGJRRA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 13:17:00 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:58260 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371AbaGJRQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 13:16:58 -0400
MIME-Version: 1.0
In-Reply-To: <20140710090150.GB10182@gchen.bj.intel.com>
References: <1404925766-32253-1-git-send-email-hskinnemoen@google.com>
	<1404925766-32253-2-git-send-email-hskinnemoen@google.com>
	<20140709191747.GB5249@pd.tnic>
	<CAFQmdRa5Spr0nX6qwzhDGEU9+H1_0vaCtF_NRV=p=OBDwin78A@mail.gmail.com>
	<20140710090150.GB10182@gchen.bj.intel.com>
Date: Thu, 10 Jul 2014 10:16:56 -0700
Message-ID: <CAFQmdRbmBDQiYxwdhLyo0kg3tZ=9X8t6+Dgabs7ZO1ZvDvekiA@mail.gmail.com>
Subject: Re: [PATCH 1/6] x86-mce: Modify CMCI poll interval to adjust for
 small check_interval values.
From: Havard Skinnemoen <hskinnemoen@google.com>
To: "Chen, Gong" <gong.chen@linux.intel.com>
Cc: Borislav Petkov <bp@alien8.de>, Tony Luck <tony.luck@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ewout van Bekkum <ewout@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2014 at 2:01 AM, Chen, Gong <gong.chen@linux.intel.com> wrote:
> On Wed, Jul 09, 2014 at 02:24:31PM -0700, Havard Skinnemoen wrote:
>> On Wed, Jul 9, 2014 at 12:17 PM, Borislav Petkov <bp@alien8.de> wrote:
>> > Why min 3 polls? How do you come up with exactly that frequency?
>>
>> The idea is that if we make it equal to check_interval, it might
>> bounce back and forth a lot. So we need to divide by something, and 8
>> seems like a nice, safe value, and it seems to work well. We're not
>> opposed to considering other values, of course (e.g. 2 and 4 might
>> work well too, but with somewhat higher risk of ping-ponging).
> That value looks chosen a little bit at will. How about updating
> CMCI_POLL_INTERVAL when check_interval is changed to ensure
> CMCI_POLL_INTERVAL <= check_interval always.

I guess that would work equally well, but we still need to determine
the magic number of how much less we want CMCI_POLL_INTERVAL to be.

Havard
