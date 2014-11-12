Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281AbaKLSOd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 13:14:33 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:46273 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085AbaKLSOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 13:14:31 -0500
Message-ID: <5463A390.2040609@wwwdotorg.org>
Date: Wed, 12 Nov 2014 11:14:40 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>, Olof Johansson <olof@lixom.net>
CC: gnurou@gmail.com, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        gregkh@linux-foundation.org
Subject: Re: [PATCH] ARM: dts: tegra: move serial aliases to per-board
References: <1415738970-7963-1-git-send-email-olof@lixom.net> <20141112122017.GC30821@ulmo.nvidia.com>
In-Reply-To: <20141112122017.GC30821@ulmo.nvidia.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2014 05:20 AM, Thierry Reding wrote:
> On Tue, Nov 11, 2014 at 12:49:30PM -0800, Olof Johansson wrote:
>> There are general changes pending to make the /aliases/serial* entries
>> number the serial ports on the system. On tegra, so far the ports have been
>> just numbered dynamically as they are configured so that makes them change.
>>
>> To avoid this, add specific aliases per board to keep the old numbers. This
>> allows us to change the numbering by default on future SoCs while keeping the
>> numbering on existing boards.
...
> I have applied this to the for-3.19/dt branch. So for anything that is
> post Tegra124 the new rule shall be to add aliases to the SoC .dtsi and
> then use consistent numbering of UART ports across boards?
>
> The alternative is to remain consistent with what this patch does, which
> would be to make the serial port numbering a property of the board. That
> doesn't sound too bad to me either since it'll hide all the unused ports
> on a given board.

For new SoCs, I think board-specific aliases would make most sense. That 
would be consistent with this patch. The only question I had was for 
existing SoCs, should we make the switch this patch does, or leave the 
aliases inactive there? New SoCs should use more sensible aliases.
