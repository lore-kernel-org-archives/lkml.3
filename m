Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751778AbaEAGYR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 02:24:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14257 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750741AbaEAGYP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 02:24:15 -0400
Date: Thu, 1 May 2014 08:24:06 +0200
From: Mateusz Guzik <mguzik@redhat.com>
To: Leon Yu <chianglungyu@gmail.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] aio: fix potential leak in aio_run_iocb().
Message-ID: <20140501062406.GB1806@mguzik.redhat.com>
References: <1398915088-8472-1-git-send-email-chianglungyu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1398915088-8472-1-git-send-email-chianglungyu@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2014 at 03:31:28AM +0000, Leon Yu wrote:
> iovec should be reclaimed whenever caller of rw_copy_check_uvector() returns,
> but it doesn't hold when failure happens right after aio_setup_vectored_rw().
> 

There is a proposal (wich a patch) to modify semantics of rw_copy_check_uvector
so that it frees stuff on error, taking care of this case as well:

https://lkml.org/lkml/2014/4/25/778

-- 
Mateusz Guzik
