Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733Ab3CTRbz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 13:31:55 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:37514 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab3CTRbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 13:31:53 -0400
Message-ID: <5149F286.30204@wwwdotorg.org>
Date: Wed, 20 Mar 2013 11:31:50 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: kishon <kishon@ti.com>
CC: Venu Byravarasu <vbyravarasu@nvidia.com>, gregkh@linuxfoundation.org,
        stern@rowland.harvard.edu, balbi@ti.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 2/7] ARM: tegra: update device trees for USB binding rework
References: <1363609781-4045-1-git-send-email-vbyravarasu@nvidia.com> <1363609781-4045-3-git-send-email-vbyravarasu@nvidia.com> <51499C29.6070405@ti.com>
In-Reply-To: <51499C29.6070405@ti.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2013 05:23 AM, kishon wrote:
> Hi,
> 
> On Monday 18 March 2013 05:59 PM, Venu Byravarasu wrote:
>> This patch updates all Tegra board files so that they contain all the
>> properties required by the updated USB DT binding. Note that this patch
>> only adds the new properties and does not yet remove the old properties,
>> in order to maintain bisectability. The old properties will be removed
>> once the driver has been updated to assume the new bindings.
>>
>> Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
>> ---
>>   arch/arm/boot/dts/tegra20-colibri-512.dtsi |    4 +++
>>   arch/arm/boot/dts/tegra20-harmony.dts      |    8 +++---
>>   arch/arm/boot/dts/tegra20-iris-512.dts     |    4 +++
>>   arch/arm/boot/dts/tegra20-paz00.dts        |    8 +++---
>>   arch/arm/boot/dts/tegra20-seaboard.dts     |   13 +++++++---
>>   arch/arm/boot/dts/tegra20-trimslice.dts    |   12 +++++++---
>>   arch/arm/boot/dts/tegra20-ventana.dts      |    7 +++--
>>   arch/arm/boot/dts/tegra20.dtsi             |   32
>> +++++++++++++++++----------
>>   8 files changed, 57 insertions(+), 31 deletions(-)
>>
>> diff --git a/arch/arm/boot/dts/tegra20-colibri-512.dtsi
>> b/arch/arm/boot/dts/tegra20-colibri-512.dtsi
>> index cb73e62..af5a7ae 100644
>> --- a/arch/arm/boot/dts/tegra20-colibri-512.dtsi
>> +++ b/arch/arm/boot/dts/tegra20-colibri-512.dtsi
>> @@ -443,6 +443,10 @@
>>           nvidia,phy-reset-gpio = <&gpio 169 0>; /* gpio PV1 */
>>       };
>>
>> +    usb-phy@c5004000 {
>
> This node doesn't have a *reg* property. So "@c5004000" is not needed.
> This comment applies to all the nodes which doesn't have *reg* property.

Yes it does have a reg property.

The node itself is first defined in tegra20.dtsi, and does contain a reg
property there.

tegra20-colibri-512.dtsi (and many other files in this patch) include
tegra20.dtsi, and simply add additional board-specific properties to the
existing node, and should not re-iterate properties that already exist.
