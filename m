Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753021AbaFRPiB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 11:38:01 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:56901 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128AbaFRPh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 11:37:59 -0400
Message-ID: <53A1B252.1030204@wwwdotorg.org>
Date: Wed, 18 Jun 2014 09:37:54 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>
CC: Mikko Perttunen <mperttunen@nvidia.com>, "tj@kernel.org" <tj@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: [PATCH 6/9] ARM: tegra: Export tegra_powergate_power_on
References: <1401881559-18469-1-git-send-email-mperttunen@nvidia.com> <1401881559-18469-7-git-send-email-mperttunen@nvidia.com> <539F691E.5030204@wwwdotorg.org> <20140617121313.GE18816@ulmo> <20140617140146.GH3407@tbergstrom-lnx.Nvidia.com> <20140617215119.GC24743@mithrandir> <20140618121806.GJ3407@tbergstrom-lnx.Nvidia.com>
In-Reply-To: <20140618121806.GJ3407@tbergstrom-lnx.Nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2014 06:18 AM, Peter De Schrijver wrote:
> On Tue, Jun 17, 2014 at 11:51:20PM +0200, Thierry Reding wrote:
>> * PGP Signed by an unknown key
>>
>> On Tue, Jun 17, 2014 at 05:01:46PM +0300, Peter De Schrijver wrote:
>>> On Tue, Jun 17, 2014 at 02:13:15PM +0200, Thierry Reding wrote:
>>>>> Old Signed by an unknown key
>>>>
>>>> On Mon, Jun 16, 2014 at 04:01:02PM -0600, Stephen Warren wrote:
>>>>> On 06/04/2014 05:32 AM, Mikko Perttunen wrote:
>>>>>> This symbol needs to be exported to power on rails without using
>>>>>> tegra_powergate_sequence_power_up. tegra_powergate_sequence_power_up
>>>>>> cannot be used in situations where the driver wants to handle clocking
>>>>>> by itself.
>>>>>
>>>>> Thierry, are you OK with this change?
>>>>
>>>> I would've preferred tegra_powergate_sequence_power_up() to be used
>>>
>>> I don't think the current tegra_powergate_sequence_power_up() API is very well
>>> defined though. I don't think the clocks and resets required by the sequence
>>> should be provided by the driver. For one, there can be several clocks and
>>> resets that need to be controlled for a single domain.
>>
>> Do you have any suggestions for what the API should look like? Even if
>> we plan to move to some different API, I think there's some advantage in
>> using it consistently if for no other reason than to make it easier to
>> replace occurrences later on.
>>
> 
> I think the API should only have the domain ID as input so:
> 
> int tegra_powerdomain_on(int id) 
> 
> /*
>  * Prerequisites: domain is off
>  * Result: domain is on, clocks of the modules in the domain are off, modules are in reset
>  */
> 
> int tegra_powerdomain_off(int id)
> 
> /*
>  * Prerequisites: all clocks of the modules in the domain are off
>  * result: domain is off
>  */

That doesn't make sense; the PMC doesn't have access to the clock and
reset IDs - that's why the API requires them to be passed in.

