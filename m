Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965231Ab3DPUyS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 16:54:18 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:48056 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965094Ab3DPUyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 16:54:17 -0400
Message-ID: <516dba78.8695320a.583d.0722@mx.google.com>
Subject: Re: [PROBLEM] perf requires python-devel to compile
Date: Tue, 16 Apr 2013 20:41:59 -0000
From: Michael Witten <mfwitten@gmail.com>
To: David Ahern <dsahern@gmail.com>
Cc: Pekka Enberg <penberg@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <516DB548.7010703@gmail.com>
References: <CAOJsxLHv17Ys3M7P5q25imkUxQW6LE_vABxh1N3Tt7Mv6Ho4iw@mail.gmail.com>
            <87mwszb4s6.fsf@sejong.aot.lge.com>
            <516CD300.6070201@gmail.com>
            <cd2c2e9aae554739b6bcd93513078f80-mfwitten@gmail.com>
            <516DB548.7010703@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Apr 2013 13:32:08 -0700, David Ahern wrote:

> On 4/16/13 10:08 AM, Michael Witten wrote:
>> You should probably disable python support more directly:
>>
>>    make NO_LIBPYTHON=1
> 
> sure, but I should not have to do anything. The intent of the existing 
> auto-probing code is to figure out what is installed and build a binary 
> with those capabilities. In this case not having python installed causes 
> it to blow up.

That's certainly how it behaved up until the regression.

To make matters worse, the NO_LIBPYTHON variable is checked only *after* 
probing for an executable `python'; in the case that no python is installed
at all, the workaround is to double up on your current trick:

  make PYTHON=false PYTHON_CONFIG=false
