Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550Ab3JLUyX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 16:54:23 -0400
Received: from mail.active-venture.com ([67.228.131.205]:60208 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275Ab3JLUyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 16:54:22 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <5259B6F8.3070701@roeck-us.net>
Date: Sat, 12 Oct 2013 13:54:16 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
CC: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Usage of for_each_child_of_node()
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

for_each_child_of_node() and similar functions increase the refcount
on each returned node and expect the caller to release the node by
calling of_node_put() when done.

Looking through the kernel code, it appears this is hardly ever done,
if at all. Some code even calls of_node_get() on returned nodes again.

I guess this doesn't matter in cases where devicetree is a static entity.
However, this is not (or no longer) the case with devicetree overlays,
or more generically in cases where devicetree nodes are added and
removed dynamically.

Fundamental question: Would patches to fix this problem be accepted upstream ?

Or, of course, stepping a bit back: Am I missing something essential ?

Thanks,
Guenter
