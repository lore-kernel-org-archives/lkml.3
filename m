Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760879Ab3DBSEz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 14:04:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29128 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759567Ab3DBSEy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 14:04:54 -0400
Date: Tue, 2 Apr 2013 20:02:19 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Frantisek Hrbata <fhrbata@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org, kamaleshb@in.ibm.com,
        hechjie@cn.ibm.com
Subject: Re: [PATCH] x86: add phys addr validity check for /dev/mem mmap
Message-ID: <20130402180219.GA26833@redhat.com>
References: <1364905733-23937-1-git-send-email-fhrbata@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364905733-23937-1-git-send-email-fhrbata@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02, Frantisek Hrbata wrote:
>
> Meaning there is a possibility to use mmap
> on /dev/mem and cause system panic. It's probably not that serious, because
> access to /dev/mem is limited and the system has to have panic_on_oops set, but
> still I think we should check this and return error.

Personally I agree. Even if panic_on_oops == F, do_page_fault(PF_RSVD) leading
to pgtable_bad() doesn't look good.

Oleg.

