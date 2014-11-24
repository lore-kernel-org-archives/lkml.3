Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751758AbaKXW0b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 17:26:31 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:59491 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbaKXW0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 17:26:25 -0500
MIME-Version: 1.0
In-Reply-To: <1416534185.6651.30.camel@perches.com>
References: <1416533715-9758-1-git-send-email-grant.likely@linaro.org>
 <1416533715-9758-2-git-send-email-grant.likely@linaro.org> <1416534185.6651.30.camel@perches.com>
From: Grant Likely <grant.likely@linaro.org>
Date: Mon, 24 Nov 2014 22:26:03 +0000
X-Google-Sender-Auth: xfMDHHw5j8xGYe2dJjeSciN_euw
Message-ID: <CACxGe6tbAZFGHshDmd8_onpwysPB4To5MqZVyLS9WbeGw=sfcw@mail.gmail.com>
Subject: Re: [PATCH 1/8] of: Use vargs in __of_node_alloc
To: Joe Perches <joe@perches.com>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        Rob Herring <robh+dt@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 1:43 AM, Joe Perches <joe@perches.com> wrote:
> On Fri, 2014-11-21 at 01:35 +0000, Grant Likely wrote:
>> The overlay code needs to construct a new full_name from the parent name
>> and the node name, but the current method has to allocate and then free
>> an temporary string which is wasteful. Fix this problem by using vargs
>> to pass in a format and arguments into __of_node_alloc().
> []
>> diff --git a/drivers/of/of_private.h b/drivers/of/of_private.h
> []
>> @@ -61,7 +61,7 @@ static inline int of_property_notify(int action, struct device_node *np,
>>   * own the devtree lock or work on detached trees only.
>>   */
>>  struct property *__of_prop_dup(const struct property *prop, gfp_t allocflags);
>> -struct device_node *__of_node_alloc(const char *full_name, gfp_t allocflags);
>
> Please add
>
> __printf(1, 2)
>> +struct device_node *__of_node_alloc(const char *fmt, ...);

Fixed, thanks.

g.
