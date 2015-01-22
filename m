Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141AbbAVRdH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 12:33:07 -0500
Received: from mail-qc0-f169.google.com ([209.85.216.169]:48760 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135AbbAVRdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 12:33:04 -0500
MIME-Version: 1.0
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Thu, 22 Jan 2015 09:32:43 -0800
Message-ID: <CAADnVQ+3exrhp8bS50HEnMrYdg4i3+K7c6ewNZHRkBqtW-uwOA@mail.gmail.com>
Subject: Re: [PATCH] samples/bpf: Fix test_maps/bpf_get_next_key() test
To: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: Alexei Starovoitov <ast@kernel.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2015 at 8:01 AM, Michael Holzheu
<holzheu@linux.vnet.ibm.com> wrote:
> Looks like the "test_maps" test case expects to get the keys in
> the wrong order when iterating over the elements:
>
> test_maps: samples/bpf/test_maps.c:79: test_hashmap_sanity: Assertion
> `bpf_get_next_key(map_fd, &key, &next_key) == 0 && next_key == 2' failed.
> Aborted
>
> Fix this and test for the correct order.

that will break this test on x86...
we need to understand first why the order of two elements
came out different on s390...
Could it be that jhash() produced different hash for the same
values on x86 vs s390 ?
The better fix for the test is probably not to assume AB or BA
order, but accept both.
