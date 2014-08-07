Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757337AbaHGIsg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 04:48:36 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:46225 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072AbaHGIse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 04:48:34 -0400
MIME-Version: 1.0
From: Aleksey Midenkov <midenok@gmail.com>
Date: Thu, 7 Aug 2014 12:48:14 +0400
Message-ID: <CAF8BazDfn==S1gG6VmHh8iT8tS6wvHHZrZyhum-i1waWOSWmiA@mail.gmail.com>
Subject: TCP ISN from userlevel
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Expansion of Linux Kernel API for getting from userlevel TCP ISN by
socket descriptor. Would such improvement deserve merge? The use case
is to differ hosts behind NAT. The general plan of changes:

1. copy ISN into the tcp_sock structure when the TCP session is created;
2. add ioctl for getting ISN;
or
2.  copy that value into the tcp_info structure returned by getsockopt().

I see that 'snt_isn' and 'rcv_isn' are stored in 'tcp_request_sock'.
Is 'tcp_request_sock' have the lifetime of 'tcp_sock'? I.e. can it be
always accessed via 'fastopen_rsk'?
