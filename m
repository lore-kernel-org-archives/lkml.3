Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861Ab3EVDa1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 23:30:27 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:37753 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753915Ab3EVDa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 23:30:26 -0400
Message-ID: <519C3BA5.1070109@huawei.com>
Date: Wed, 22 May 2013 11:29:41 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] ktap 0.1 released
References: <519AF05E.1050808@huawei.com> <20130521161903.333d7e74@lwn.net>
In-Reply-To: <20130521161903.333d7e74@lwn.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/5/22 6:19, Jonathan Corbet wrote:
> On Tue, 21 May 2013 11:56:14 +0800
> "zhangwei(Jovi)" <jovi.zhangwei@huawei.com> wrote:
> 
>> we welcome bug reports and fixes for the issues.
> 
> I'm messing with it...first impression:
> 
> 	unable create tracepoint event sys_enter_mmap on cpu 4, err: -19
> 	unable create tracepoint event sys_enter_mmap on cpu 5, err: -19
> 	unable create tracepoint event sys_enter_mmap on cpu 6, err: -19
> 	unable create tracepoint event sys_enter_mmap on cpu 7, err: -19
> 	[...]
> 
> Unsurprising, this is a four-core system.  The code reads:
> 
>> 	for_each_possible_cpu(cpu)
>> 		enable_tracepoint_on_cpu(cpu, &attr, call, arg, type);
> 
> Maybe that needs to be for_each_online_cpu() instead?
> 
Jon, Really thank you for this bug report, fixed it as your suggestion.

.jovi





