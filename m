Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056AbaJAVsg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 17:48:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44852 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbaJAVsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 17:48:35 -0400
Date: Wed, 1 Oct 2014 14:48:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hughd@google.com,
        mgorman@suse.de
Subject: Re: [PATCH 0/5] mm: poison critical mm/ structs
Message-Id: <20141001144834.ff3ff0349951df734d159fb3@linux-foundation.org>
In-Reply-To: <542C749B.1040103@oracle.com>
References: <1412041639-23617-1-git-send-email-sasha.levin@oracle.com>
	<20141001140725.fd7f1d0cf933fbc2aa9fc1b1@linux-foundation.org>
	<542C749B.1040103@oracle.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 01 Oct 2014 17:39:39 -0400 Sasha Levin <sasha.levin@oracle.com> wrote:

> > It looks fairly cheap - I wonder if it should simply fall under
> > CONFIG_DEBUG_VM rather than the new CONFIG_DEBUG_VM_POISON.
> 
> Config options are cheap as well :)

Thing is, lots of people are enabling CONFIG_DEBUG_VM, but a smaller
number of people will enable CONFIG_DEBUG_VM_POISON.  Less coverage. 

Defaulting to y if CONFIG_DEBUG_VM might help, but if people do `make
oldconfig' when CONFIG_DEBUG_VM=n, their CONFIG_DEBUG_VM_POISON will
get set to `n' and will remain that way when they set CONFIG_DEBUG_VM
again.

