Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751851AbaHWP5y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 11:57:54 -0400
Received: from qmta03.emeryville.ca.mail.comcast.net ([76.96.30.32]:58145 "EHLO
	qmta03.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751326AbaHWP5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 11:57:53 -0400
Date: Sat, 23 Aug 2014 10:57:47 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Tejun Heo <tj@kernel.org>
cc: akpm@linux-foundation.org, laijs@cn.fujitsu.com,
        linux-kernel@vger.kernel.org, vgoyal@redhat.com
Subject: Re: [PATCH 03/15] percpu: remove the usage of separate populated
 bitmap in percpu-vm
In-Reply-To: <1408726399-4436-4-git-send-email-tj@kernel.org>
Message-ID: <alpine.DEB.2.11.1408231054580.29970@gentwo.org>
References: <1408726399-4436-1-git-send-email-tj@kernel.org> <1408726399-4436-4-git-send-email-tj@kernel.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Aug 2014, Tejun Heo wrote:

> percpu-vm uses pcpu_get_pages_and_bitmap() to acquire temp pages array
> and populated bitmap and uses the two during [de]population.  The temp
> bitmap is used only to build the new bitmap that is copied to
> chunk->populated after the operation succeeds; however, the new bitmap
> can be trivially set after success without using the temp bitmap.

Ok so that follows from the all or nothing allocation approach. Either all
the pages have been allocated then you can set the bits or not then you
clear them.

Acked-by: Christoph Lameter <cl@linux.com>
