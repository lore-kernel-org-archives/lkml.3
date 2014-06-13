Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240AbaFMNt0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 09:49:26 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:61017 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373AbaFMNtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 09:49:25 -0400
Message-ID: <1402667259.6072.20.camel@debian>
Subject: Re: [RESEND PATCH v2] mm/vmscan.c: wrap five parameters into
 writeback_stats for reducing the stack consumption
From: Chen Yucong <slaoub@gmail.com>
To: akpm@linux-foundation.org
Cc: mgorman@suse.de, hannes@cmpxchg.org, mhocko@suse.cz, riel@redhat.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <1402639088-4845-1-git-send-email-slaoub@gmail.com>
References: <1402639088-4845-1-git-send-email-slaoub@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 Jun 2014 21:47:39 +0800
Mime-Version: 1.0
X-Mailer: Evolution 3.4.4-3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

On Fri, 2014-06-13 at 13:58 +0800, Chen Yucong wrote:
> shrink_page_list() has too many arguments that have already reached ten.
> Some of those arguments and temporary variables introduces extra 80 bytes
> on the stack. This patch wraps five parameters into writeback_stats and removes
> some temporary variables, thus making the relative functions to consume fewer
> stack space.
> 
I this message, I have renamed shrink_result to writeback_stats
according to Johannes Weiner's reply. Think carefully, this change is
too hasty. Although it now just contains statistics on the writeback
states of the scanned pages, it may also be used for gathering other
information at some point in the future. So I think shrink_result is a
little bit better!

thx!
cyc


