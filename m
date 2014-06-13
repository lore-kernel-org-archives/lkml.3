Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786AbaFMVNS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 17:13:18 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:57827 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236AbaFMVNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 17:13:16 -0400
MIME-Version: 1.0
In-Reply-To: <539B2B7F.8010900@gmail.com>
References: <539A91E2.7000606@gmail.com> <CAL_JsqJ+f0CjwGnqTzXjMOAvbDOf0O3BZgcQwrzaWBy9Gwiw8A@mail.gmail.com>
 <539B2B7F.8010900@gmail.com>
From: Rob Herring <robherring2@gmail.com>
Date: Fri, 13 Jun 2014 16:12:55 -0500
Message-ID: <CAL_JsqLs7m_ouruWzjq6rnEwWamsDgNMmE+WAo-+W9DMLMUXAQ@mail.gmail.com>
Subject: Re: [RFC PATCH] OF: fix of_find_node_by_path() assumption that
 of_allnodes is root
To: Frank Rowand <frowand.list@gmail.com>
Cc: Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 11:49 AM, Frank Rowand <frowand.list@gmail.com> wrote:
> On 6/13/2014 6:52 AM, Rob Herring wrote:
>> On Fri, Jun 13, 2014 at 12:53 AM, Frank Rowand <frowand.list@gmail.com> wrote:
>>> From: Frank Rowand <frank.rowand@sonymobile.com>
>>>
>>> Pantelis Antoniou reports that of_find_node_by_path() is borked because
>>> of_allnodes is not guaranteed to contain the root of the tree after using
>>> any of the dynamic update functions because some other nodes ends up as
>>> of_allnodes.
>>>
>>> Fixes: c22e650e66b8 of: Make of_find_node_by_path() handle /aliases
>>
>> Is it not possible to do a fix in of_find_node_by_path instead? I just
>
> Yes, the code for that is in https://lkml.org/lkml/2014/5/20/758
>
> Or as Grant said in his reply, just use the fix in of_attach_node() for
> now since he is going to replace the custom list.

Okay, I've applied.

Rob
