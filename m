Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290Ab3H1UZz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 16:25:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52184 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381Ab3H1UZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 16:25:53 -0400
Date: Wed, 28 Aug 2013 13:25:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kent Overstreet <kmo@daterainc.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        target-devel <target-devel@vger.kernel.org>,
        lf-virt <virtualization@lists.linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, Asias He <asias@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Christoph Lameter <cl@gentwo.org>, Oleg Nesterov <oleg@redhat.com>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH] percpu ida: Switch to cpumask_t, add some comments
Message-Id: <20130828132550.d0ce4d3a4d40ee07e7e8a1c1@linux-foundation.org>
In-Reply-To: <20130828195517.GF8032@kmo-pixel>
References: <1376694549-20609-1-git-send-email-nab@linux-iscsi.org>
	<1376694549-20609-2-git-send-email-nab@linux-iscsi.org>
	<20130820143157.f91bf59d16352989b54e431e@linux-foundation.org>
	<20130828195517.GF8032@kmo-pixel>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Aug 2013 12:55:17 -0700 Kent Overstreet <kmo@daterainc.com> wrote:

> Fixup patch, addressing Andrew's review feedback:

Looks reasonable.

>  lib/idr.c           | 38 +++++++++++++++++++++-----------------

I still don't think it should be in this file.

You say that some as-yet-unmerged patches will tie the new code into
the old ida code.  But will it do it in a manner which requires that
the two reside in the same file?

