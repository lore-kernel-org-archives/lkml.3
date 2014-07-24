Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759209AbaGXK3R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 06:29:17 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:8814 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758076AbaGXJqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:46:39 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 24 Jul 2014 02:38:42 -0700
Message-ID: <53D0D5B5.6010904@nvidia.com>
Date: Thu, 24 Jul 2014 15:15:25 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
CC: "milo.kim@ti.com" <milo.kim@ti.com>,
        "support.opensource@diasemi.com" <support.opensource@diasemi.com>,
        "patches@opensource.wolfsonmicro.com" 
	<patches@opensource.wolfsonmicro.com>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: drivers: fix return value of get_mode callback
References: <1405333997-28764-1-git-send-email-ldewangan@nvidia.com> <20140714115718.GA18724@opensource.wolfsonmicro.com> <20140714180114.GJ6800@sirena.org.uk>
In-Reply-To: <20140714180114.GJ6800@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark
On Monday 14 July 2014 11:31 PM, Mark Brown wrote:
> * PGP Signed by an unknown key
>
> On Mon, Jul 14, 2014 at 12:57:18PM +0100, Charles Keepax wrote:
>> On Mon, Jul 14, 2014 at 04:03:17PM +0530, Laxman Dewangan wrote:
> It's because it's returning something defined as a bitmask, though since
> we don't even have enough modes for 8 bits that's not really a strong
> reason and we should just be returning an error code as everyone is
> clearly already assuming we do.
>
Just to confirm, do you want to change the return type of get_mode() to 
"int" instead of
unsigned int? And then return proper error type?

In this case I think it should be single patch (core + driver).

