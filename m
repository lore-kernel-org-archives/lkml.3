Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518AbaLOQoc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 11:44:32 -0500
Received: from ext3.cumulusnetworks.com ([198.211.106.187]:59350 "EHLO
	ext3.cumulusnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbaLOQo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 11:44:29 -0500
Message-ID: <548F0FE7.1080603@cumulusnetworks.com>
Date: Mon, 15 Dec 2014 08:44:23 -0800
From: Roopa Prabhu <roopa@cumulusnetworks.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Thomas Graf <tgraf@suug.ch>
CC: "Varlese, Marco" <marco.varlese@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "Fastabend, John R" <john.r.fastabend@intel.com>,
        "sfeldma@gmail.com" <sfeldma@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH net-next 1/1] net: Support for switch port configuration
References: <C4896FB061E7DE4AAC93031BDCA044B104AC3257@IRSMSX108.ger.corp.intel.com> <20141210165018.GG1863@nanopsycho.orion> <54887CF7.70708@gmail.com> <C4896FB061E7DE4AAC93031BDCA044B104AC3914@IRSMSX108.ger.corp.intel.com> <20141215140749.GB21952@casper.infradead.org> <C4896FB061E7DE4AAC93031BDCA044B104AC5DCF@IRSMSX108.ger.corp.intel.com> <20141215144027.GA21262@casper.infradead.org>
In-Reply-To: <20141215144027.GA21262@casper.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/14, 6:40 AM, Thomas Graf wrote:
> On 12/15/14 at 02:29pm, Varlese, Marco wrote:
>>> All of these are highly generic and should *not* be passed through from user
>>> space to the driver directly but rather be properly abstracted as Roopa
>>> proposed. The value of this API is abstraction.
>> How would you let the user enable/disable features then? For instance, how would the user enable/disable flooding for broadcast packets (BFLOODING) on a given port? What I was proposing is to have a list of attributes (to be added in if_link.h) which can be tuned by the user using a tool like iproute2. What do you propose?
> Excellent, I agree with what you are saying. What set me off is that
> the patch does not reflect that yet. Instead, the patch introduces
> a pure Netlink pass-through API to the driver.
>
> I would expect the patch to:
>   1. Parse the Netlink messages and be aware of individual attributes
>   2. Validate them
>   3. Pass the configuration to the driver using an API that can also
>      be consumed from in-kernel users.
yes, exactly.
>
>> I think I have seen Roopa posting his updated ndo patch and getting some feedback by few people already and as long as I will be able to accomplish the use case described here I am happy with his way.
> I think Roopa's patches are supplementary. Not all switchdev users
> will be backed with a Linux Bridge. I therefore welcome your patches
> very much.
>
> The overlap is in the ndo. I think both the API you propose and
> Roopa's bridge code should use the same NDO.
>> I do not have an example right now of a vendor specific attribute but I was just saying that might happen (i.e. someone will have a feature not implemented by others?).
> That's fine. Once we have them we can consider adding vendor specific
> extensions.

