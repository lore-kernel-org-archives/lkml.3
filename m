Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759675Ab3EAWsJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 18:48:09 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:33531 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757477Ab3EAWsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 18:48:07 -0400
Date: Wed, 1 May 2013 15:48:05 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Cody P Schafer <cody@linux.vnet.ibm.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] memory_hotplug: use pgdat_resize_lock() when updating
 node_present_pages
In-Reply-To: <518199FE.7060908@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.02.1305011547450.8804@chino.kir.corp.google.com>
References: <1367446635-12856-1-git-send-email-cody@linux.vnet.ibm.com> <1367446635-12856-5-git-send-email-cody@linux.vnet.ibm.com> <alpine.DEB.2.02.1305011530050.8804@chino.kir.corp.google.com> <518199FE.7060908@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 May 2013, Cody P Schafer wrote:

> Guaranteed to be stable means that if I'm a reader and pgdat_resize_lock(),
> node_present_pages had better not change at all until I pgdat_resize_unlock().
> 
> If nothing needs this guarantee, we should change the rules of
> pgdat_resize_lock(). I played it safe and went with following the existing
> rules.
> 

__offline_pages() breaks your guarantee.
