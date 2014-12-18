Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751765AbaLRWOF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 17:14:05 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:52750 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbaLRWOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 17:14:03 -0500
Message-ID: <549351A7.9040408@gmail.com>
Date: Thu, 18 Dec 2014 15:13:59 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: acme@kernel.org, linux-kernel@vger.kernel.org,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] tools lib traceevent: Add support for IP address formats
References: <1418915443-45707-1-git-send-email-dsahern@gmail.com> <17321.1418939104@turing-police.cc.vt.edu>
In-Reply-To: <17321.1418939104@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/14 2:45 PM, Valdis.Kletnieks@vt.edu wrote:
> On Thu, 18 Dec 2014 08:10:43 -0700, David Ahern said:
>> Adds helper for following kernel formats:
>>    %pi4 print an IPv4 address with leading zeros
>>    %pI4 print an IPv4 address without leading zeros
>>    %pi6 print an IPv6 address without colons
>>    %pI6 print an IPv6 address with colons
>>    %pI6c print an IPv6 address with colons
>>    %pISpc print an IP address from a sockaddr
>
> The description for %pI6C in the changelog doesn't match the code:
>
>> + * %pI6c  print an IPv6 address in compressed form with colons
>
> Threw me for a loop for a while trying to figure out how pI6 and pI6c were
> different, till I read the code...
>

Per Documentation/printk-formats.txt:

   %pI6    0001:0002:0003:0004:0005:0006:0007:0008
   %pi6    00010002000300040005000600070008
   %pI6c   1:2:3:4:5:6:7:8

   For printing IPv6 network-order 16-bit hex addresses. The 'I6' and 'i6'
   specifiers result in a printed address with ('I6') or without ('i6')
   colon-separators. Leading zeros are always used.

   The additional 'c' specifier can be used with the 'I' specifier to
   print a compressed IPv6 address as described by
         http://tools.ietf.org/html/rfc5952



I do see two mistakes in my patch -- use of 'c' and 'S' requires 'I'. 
After that the code that prints pI6c is a slightly modified version of 
what is in lib/vsprintf.c so the output between in-kernel tracing (cat 
trace_pipe) should match perf-script output. Compare 
ip6_compressed_string() in lib/vsprintf.c to print_ip6c_addr() in this 
patch.

Are you seeing something different?

David

