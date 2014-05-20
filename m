Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751700AbaETGps (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 02:45:48 -0400
Received: from mail.southpole.se ([37.247.8.11]:43288 "EHLO mail.southpole.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750731AbaETGpr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 02:45:47 -0400
Message-ID: <537AFA18.7050705@southpole.se>
Date: Tue, 20 May 2014 08:45:44 +0200
From: Jonas Bonn <jonas@southpole.se>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
CC: linux-kernel@vger.kernel.org, linux@openrisc.net
Subject: Re: [PATCH] openrisc: irq: use irqchip framework
References: <1400502328-23974-1-git-send-email-stefan.kristiansson@saunalahti.fi> <537A18E9.4010301@southpole.se> <20140519195433.GA18318@chokladfabriken.org>
In-Reply-To: <20140519195433.GA18318@chokladfabriken.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Assp-Version: 2.4.1(14097) on assp.southpole.se
X-Assp-ID: assp.southpole.se 68343-08327
X-Assp-Session: 7FF52FC49560 (mail 1)
X-Assp-Client-TLS: yes
X-Assp-Server-TLS: yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/2014 09:54 PM, Stefan Kristiansson wrote:
> On Mon, May 19, 2014 at 04:44:57PM +0200, Jonas Bonn wrote:
> 
>> ii) Put a Depends on CONFIG_ARCH_OPENRISC in the Kconfig
> 
> Hmm, do we really need that?
> The irqchip driver will picked by 'select'ing it from arch/openrisc/Kconfig
> So, it won't really be exposed to anyone not explicitly picking it like that.
> 

It will be exposed by allyesconfig.  The driver uses mfspr which is
openrisc-only, so the driver really needs to hide behind an
openrisc-arch config option.

/Jonas
