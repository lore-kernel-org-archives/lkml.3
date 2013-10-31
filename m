Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105Ab3JaKcQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 06:32:16 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:64113 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975Ab3JaKcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 06:32:14 -0400
MIME-Version: 1.0
In-Reply-To: <20131030202221.047149911@openvz.org>
References: <20131030195951.201688764@openvz.org>
	<20131030202221.047149911@openvz.org>
Date: Thu, 31 Oct 2013 13:32:13 +0300
Message-ID: <CACVxJT8vuh+Jm1LYhiQBLvi6TASpGgKm0CCqVS=g3QE+eHK7Wg@mail.gmail.com>
Subject: Re: [patch 1/6] procfs: Introduce sequential fdinfo engine
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>, Oleg Nesterov <oleg@redhat.com>,
        Andrey Vagin <avagin@openvz.org>, Al Viro <viro@zeniv.linux.org.uk>,
        James Bottomley <jbottomley@parallels.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 10:59 PM, Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> At moment the fdinfo operations (ie the output from /proc/$pid/fdinfo/$fd)
> are generating output in one pass, which makes useless memory pressue
> if the reader/user provides a buffer with a small size.

cat(1) uses 64 KB buffer.
The output doesn't exceed one page anyway.
