Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936119Ab3DKPPc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 11:15:32 -0400
Received: from mail-vb0-f42.google.com ([209.85.212.42]:53047 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932840Ab3DKPPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 11:15:30 -0400
Message-ID: <5166D390.8050704@gmail.com>
Date: Thu, 11 Apr 2013 11:15:28 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Mitsuhiro Tanino <mitsuhiro.tanino.gm@hitachi.com>
CC: Andi Kleen <andi@firstfloor.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, kosaki.motohiro@gmail.com
Subject: Re: [RFC Patch 0/2] mm: Add parameters to make kernel behavior at
 memory error on dirty cache selectable
References: <51662D5B.3050001@hitachi.com>
In-Reply-To: <51662D5B.3050001@hitachi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(4/10/13 11:26 PM), Mitsuhiro Tanino wrote:
> Hi All,
> Please find a patch set that introduces these new sysctl interfaces,
> to handle a case when an memory error is detected on dirty page cache.
> 
> - vm.memory_failure_dirty_panic

Panic knob is ok to me. However I agree with Andi. If we need panic know,
it should handle generic IO error and data lost.


> - vm.memory_failure_print_ratelimit
> - vm.memory_failure_print_ratelimit_burst

But this is totally silly. 
print_ratelimit might ommit important messages. Please do a right way.


