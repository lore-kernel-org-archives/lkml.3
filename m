Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751568AbaLEKe5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 05:34:57 -0500
Received: from service87.mimecast.com ([91.220.42.44]:57048 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbaLEKe4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 05:34:56 -0500
Message-ID: <54818A4B.60100@arm.com>
Date: Fri, 05 Dec 2014 10:34:51 +0000
From: "Suzuki K. Poulose" <Suzuki.Poulose@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Steven Stewart-Gallus <sstewartgallus00@mylangara.bc.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: How can I parse the command name from /proc/<pid>/stat?
References: <fc15da367389.5480b999@langara.bc.ca>
In-Reply-To: <fc15da367389.5480b999@langara.bc.ca>
X-OriginalArrivalTime: 05 Dec 2014 10:34:52.0062 (UTC) FILETIME=[1A35A3E0:01D01077]
X-MC-Unique: 114120510345306401
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/14 19:44, Steven Stewart-Gallus wrote:
> Hello,
>
> Given an evil hacker trying to confuse process monitors that might use such
> strange process names as 'pause) R 0 0 (foo' how can I correctly parse the
> command name from /proc/<pid>/stat? Maybe I should just use /proc/<pid>/status?
> Maybe there should be some documentation written on the issue? I just wanted to
> send an email off to check if I was missing anything before writing a few small
> additions to the documentation or filing a bug report. procps-ng seems to use an
> ugly hack that involves knowing the limits on the size of a possible command
> name that I'm not actually sure works totally correctly.

You can do something like :

cmd_start = strchr(stat_buf, '(');
cmd_end = strrchr(stat_buf, ')');

Cheers
Suzuki


>
> Thank you,
> Steven Stewart-Gallus
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>


