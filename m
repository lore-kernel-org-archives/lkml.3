Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935Ab3H0IIt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 04:08:49 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:39935 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055Ab3H0IIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 04:08:46 -0400
X-AuditID: 85900ec0-d1328b9000001514-3e-521c5e8c8a54
Message-ID: <521C5E8A.4020308@hitachi.com>
Date: Tue, 27 Aug 2013 17:08:42 +0900
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120604 Thunderbird/13.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com
Subject: Re: Re: [RFC PATCH 07/11] [CLEANUP] trace-cmd: Split out binding
 a port and fork reader from open_udp()
References: <20130819094620.26597.79499.stgit@yunodevel> <20130819094637.26597.35505.stgit@yunodevel> <20130820134902.3a06e4d0@gandalf.local.home> <521AB3DF.3070505@hitachi.com> <20130826103726.60f92fbc@gandalf.local.home>
In-Reply-To: <20130826103726.60f92fbc@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/08/26 23:37), Steven Rostedt wrote:
> On Mon, 26 Aug 2013 10:48:15 +0900
> Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com> wrote:
>
>
>>>> +static int open_udp(const char *node, const char *port, int *pid,
>>>> +		    int cpu, int pagesize, int start_port)
>>>> +{
>>>> +	int sfd;
>>>> +	int num_port;
>>>> +
>>>> +	num_port = udp_bind_a_port(start_port, &sfd);
>>>> +	if (num_port < 0)
>>>> +		return num_port;
>>>
>>> I don't see how num_port could be less than zero.
>>
>> I think so, but trace-cmd checks whether udp_port is less than zero or
>> not in create_all_readers().
>>
>> May I submit the removal patch?
>
> It's not a critical path, the check is fine. As there was a check, I
> was thinking that you were expecting it to pass an error which it never
> did.
>
> Perhaps just add a comment stating that udp_bind_a_port() currently
> does not return an error, but if that changes in the future, we have a
> check for it now.
>
> That way a reviewer of the code does not get confused by it.

OK, I'll delete the check and add comment as follows:

/*
  * udp_bind_a_port() currently does not return an error, but if that
  * changes in the future, we have a check for it now.
  */
num_port = udp_bind_a_port(start_port, &sfd);

Thanks,
Yoshihiro YUNOMAE

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com


