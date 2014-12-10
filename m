Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932485AbaLJREK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 12:04:10 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:48878 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932247AbaLJREI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 12:04:08 -0500
Message-ID: <54887CF7.70708@gmail.com>
Date: Wed, 10 Dec 2014 09:03:51 -0800
From: John Fastabend <john.fastabend@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Jiri Pirko <jiri@resnulli.us>
CC: "Varlese, Marco" <marco.varlese@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "Fastabend, John R" <john.r.fastabend@intel.com>,
        "roopa@cumulusnetworks.com" <roopa@cumulusnetworks.com>,
        "sfeldma@gmail.com" <sfeldma@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH net-next 1/1] net: Support for switch port configuration
References: <C4896FB061E7DE4AAC93031BDCA044B104AC3257@IRSMSX108.ger.corp.intel.com> <20141210165018.GG1863@nanopsycho.orion>
In-Reply-To: <20141210165018.GG1863@nanopsycho.orion>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2014 08:50 AM, Jiri Pirko wrote:
> Wed, Dec 10, 2014 at 05:23:40PM CET, marco.varlese@intel.com wrote:
>> From: Marco Varlese <marco.varlese@intel.com>
>>
>> Switch hardware offers a list of attributes that are configurable
>> on a per port basis.
>> This patch provides a mechanism to configure switch ports by adding
>> an NDO for setting specific values to specific attributes.
>> There will be a separate patch that extends iproute2 to call the
>> new NDO.
>
>
> What are these attributes? Can you give some examples. I'm asking
> because there is a plan to pass generic attributes to switch ports
> replacing current specific ndo_switch_port_stp_update. In this case,
> bridge is setting that attribute.
>
> Is there need to set something directly from userspace or does it make
> rather sense to use involved bridge/ovs/bond ? I think that both will be
> needed.

+1

I think for many attributes it would be best to have both. The in
kernel callers and netlink userspace can use the same driver ndo_ops.

But then we don't _require_ any specific bridge/ovs/etc module. And we
may have some attributes that are not specific to any existing software
module. I'm guessing Marco has some examples of these.

[...]


-- 
John Fastabend         Intel Corporation
