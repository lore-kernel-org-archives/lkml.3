Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932835Ab3BLK0l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 05:26:41 -0500
Received: from mail-vc0-f169.google.com ([209.85.220.169]:43818 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758839Ab3BLK0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 05:26:38 -0500
MIME-Version: 1.0
From: Andrey Korolyov <andrey@xdel.ru>
Date: Tue, 12 Feb 2013 13:26:16 +0300
Message-ID: <CABYiri-99F++CuaetzS1qUbffqNE-P=4Q-XYW7q8QvJ2jxTaug@mail.gmail.com>
Subject: Lockups using per-thread cgs and kvm
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

We (a cloud hosting provider) has recently observed a couple of
strange lockups when physical node runs significant amount of
Win2008R2 kvm appliances, one may see collection of those lockups at
the link below. After checking a lot of ideas without any valuable
result, I have suggested that nested per-thread cgroup placement
created by libvirt may lead to this problem(libvirt puts emulator and
each of vcpu threads into separate sub-cgroup). Disabling such
behavior, e.g. having only one cgroup per kvm process per cgroup type
solved this problem, at least it didn`t happen on most stressful tests
we`re able to do. Since it is generally unusual for well-known kernel
mechanism, such as cgroups, to broke way like this, I hope we`ve found
a quite rare kind of bug. Just for the record, the bug also may happen
using linux guest, but much rarely, one or two orders of magnitude. We
have stayed on default scheduler granularity value at this tests, if
it matters.

For anyone who wants to see entire timeline of this bug, please see [1].


[1]. http://www.spinics.net/lists/kvm/msg85956.html
