Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735AbaG2OZ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 10:25:28 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:4545 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979AbaG2OZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 10:25:26 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 29 Jul 2014 07:17:10 -0700
Message-ID: <53D7AE7E.8070104@nvidia.com>
Date: Tue, 29 Jul 2014 19:53:58 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Eduardo Valentin <edubezval@gmail.com>
CC: "rui.zhang@intel.com" <rui.zhang@intel.com>,
        "eduardo.valentin@gmail.com" <eduardo.valentin@gmail.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "javi.merino@arm.com" <javi.merino@arm.com>
Subject: Re: [PATCH-REPOST] thermal: of: look for sensor driver parent node
 if device node missing
References: <1406279971-14957-1-git-send-email-ldewangan@nvidia.com> <20140729141234.GA26807@developer>
In-Reply-To: <20140729141234.GA26807@developer>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 July 2014 07:42 PM, Eduardo Valentin wrote:
> Hello Laxman,
>
> On Fri, Jul 25, 2014 at 02:49:31PM +0530, Laxman Dewangan wrote:
>> There are some mfd devices which supports junction thermal interrupt
>> like ams,AS3722. The DT binding of these devices are defined as the
>> flat and drivers for sub module of such devices are registered as
>> the mfd_add_devices. In this method, the sub devices registered as
>> platform driver and these do not have the of_node pointer on their
>> device structure. In this case, use the parent of_node pointer to
>> get the required of_node pointer.
>>
> Can you please elaborate a bit more on your proposal? So, you would
> append the thermal zones on the DT node of the MFD device?

Yes, mfd node for ams,as3722 is flat node, almost all sub-module driver 
have their property on this node only. Regulator have their own sub node 
under this node.

as3722 {
         compatible = "ams,as3722";
         #gpio-contorller;
         #gpio-cells = <2>;
     ::::::::::
         regulator {
                 ::::
         };
};


So in this, the thermal sensor driver's property is on the as3722 node 
only and thermal zone need to refer this node for sensor.

However, as3722 thermal sensor driver is register as sub mfd devices 
through mfd_add_devices() and thermal sensor drivers pdev->dev.of_node 
does not have any valid pointer.
