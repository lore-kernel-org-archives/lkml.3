Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359Ab3EURpI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 13:45:08 -0400
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:49714 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754878Ab3EURpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 13:45:06 -0400
Message-ID: <519BB29D.9010104@hurleysoftware.com>
Date: Tue, 21 May 2013 13:45:01 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Wang YanQing <udknight@gmail.com>
CC: gregkh@linuxfoundation.org, sfr@canb.auug.org.au,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] TTY:vt: convert remain take_over_console's users to do_take_over_console
References: <20130521051511.GA11435@udknight> <519B7249.2070207@hurleysoftware.com> <20130521144215.GA5302@udknight.homenetwork> <519B976A.3050708@hurleysoftware.com> <20130521161849.GA11322@udknight.homenetwork> <20130521162958.GA1927@udknight>
In-Reply-To: <20130521162958.GA1927@udknight>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2013 12:29 PM, Wang YanQing wrote:
> On Wed, May 22, 2013 at 12:18:49AM +0800, Wang YanQing wrote:
>>> Except now you're spreading the brokenness that is console_lock()
>>> over many more source files than the single-use case of
>>> do_take_over_console().
>>
>>> The actual interface is take_over_console(); the _workaround_ is
>>> exposing do_take_over_console() for fbcon to wrap.
>>
>> This _workaround_ willn't work, take_over_console will hold console_lock internal,
>> but do_take_over_console need caller hold console_lock, then we can't rewrite
>> do_take_over_console as a wrap base on take_over_console.

The workaround I'm referring to is commit 50e244cc793 which
exposed do_take_over_console() as an interface to band aid the lock
problems.

I'm ok with take_over_console() being a lock wrapper around
do_take_over_console(), if you are trying to preserve your
other changes.

Regards,
Peter Hurley



