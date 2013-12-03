Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755116Ab3LCUI2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 15:08:28 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:43943 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755038Ab3LCUIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 15:08:24 -0500
Message-ID: <529E3A34.4030206@wwwdotorg.org>
Date: Tue, 03 Dec 2013 13:08:20 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>
CC: "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] ARM: dts: tegra: Header file for pinctrl constants
References: <1385992502-12771-1-git-send-email-ldewangan@nvidia.com> <20131202142522.GA17566@ulmo.nvidia.com> <529D745D.2070503@nvidia.com>
In-Reply-To: <529D745D.2070503@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2013 11:04 PM, Laxman Dewangan wrote:
> On Monday 02 December 2013 07:55 PM, Thierry Reding wrote:
>> * PGP Signed by an unknown key
>>
>> On Mon, Dec 02, 2013 at 07:25:01PM +0530, Laxman Dewangan wrote:
>>
> 
>> +
>> +/* Schmitt enable/disable */
>> +#define TEGRA_PIN_DRIVE_SCHMITT_DISABLE            0
>> +#define TEGRA_PIN_DRIVE_SCHMITT_ENABLE            1
>> These are all boolean, so I wonder if perhaps we should be simply
>> defining a single pair and reuse that in different contexts:
>>
>>     #define TEGRA_PIN_DISABLE    0
>>     #define TEGRA_PIN_ENABLE    1
>>
>> The property names should provide enough context for them to be used
>> unambiguously.
>>
>>
> 
> I can make generic ENABLE/DISABLE macro as you suggested but datasheet
> says as 0=NORMAL, 1 = TRISTATE. and that's why I kept name very near to
> the datasheet.

That documentation is relative to a specific field, whereas the
namespace for #defines is global. Hence, we may have to name #defines
using stricter rules than the TRM's field values, in order to make them
unambiguous.
