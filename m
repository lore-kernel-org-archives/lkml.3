Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509Ab3H0N6Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 09:58:16 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:35416 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925Ab3H0N6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 09:58:15 -0400
Message-ID: <521CB074.3040900@gmail.com>
Date: Tue, 27 Aug 2013 07:58:12 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Dave Jones <davej@redhat.com>, paulmck@linux.vnet.ibm.com,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: suspicious RCU usage (perf)
References: <20130826145838.GA8377@redhat.com> <20130826162928.GQ3871@linux.vnet.ibm.com> <20130826133041.3d750b1b@gandalf.local.home> <20130826175012.GA25202@redhat.com> <20130826141814.54dcaa89@gandalf.local.home> <20130826182907.GB25202@redhat.com> <521BAFD3.2060404@gmail.com> <20130826194923.GA1549@redhat.com> <20130827091011.18ed8b59@gandalf.local.home>
In-Reply-To: <20130827091011.18ed8b59@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/27/13 7:10 AM, Steven Rostedt wrote:
> On Mon, 26 Aug 2013 15:49:24 -0400
> Dave Jones <davej@redhat.com> wrote:
>
>
>>   > Do you have /sys/kernel/debug with access permissions?
>>
>> Ah, yeah, that'll be it. Good catch.
>>
>> Sorry for the false alarm Steve ;)
>
> Yeah, but it still does not explain how perf got started. Perf requires
> a sys_perf_event_open() call to run.

Per Peter's response another option is the paranoia level:

# perf event paranoia level:
# -1 - not paranoid at all
#  0 - disallow raw tracepoint access for unpriv
#  1 - disallow cpu events for unpriv
#  2 - disallow kernel profiling for unpriv
kernel.perf_event_paranoid = -1

I keep my dev box at -1 and set /sys/kernel/debug to 755 to run perf as 
non-root.

David
