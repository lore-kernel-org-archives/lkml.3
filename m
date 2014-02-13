Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620AbaBMJas (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 04:30:48 -0500
Received: from mail-oa0-f50.google.com ([209.85.219.50]:56346 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbaBMJan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 04:30:43 -0500
MIME-Version: 1.0
Date: Thu, 13 Feb 2014 04:30:42 -0500
X-Google-Sender-Auth: FdeEpwgMotHW52cI6nnfnayG72s
Message-ID: <CAKb7UvhsLi2Sv4SWA2nVTgoFV8dzrY=3R1-SUk9D-aa0VdizSA@mail.gmail.com>
Subject: ip_set: protocol %u message -- useful?
From: Ilia Mirkin <imirkin@alum.mit.edu>
To: netdev@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Patrick McHardy <kaber@trash.net>, Vitaly Lavrov <lve@guap.ru>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I've recently noticed a lot of

[356872.380595] ip_set: protocol 6

messages in my dmesg. This might be because of some local
configuration changes I've made, or perhaps a kernel upgrade. Either
way, it appears this message has been a pr_notice since the original
code added it in a7b4f989a62 ("netfilter: ipset: IP set core
support").

Does this message provide a lot of value? Or could it be made into a pr_debug?

FWIW commit 1785e8f473 ("netfiler: ipset: Add net namespace for
ipset"), merged in v3.13-rc1 changed the code around which may have
made it more likely to appear in dmesg (with the namespace stuff). Not
sure though. I don't (purposely) use namespaces.

I'm happy to put together a patch demoting it to pr_debug if people
think it's OK.

Thanks,

  -ilia
