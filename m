Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755062AbaIHRvT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 13:51:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:33541 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083AbaIHRvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 13:51:17 -0400
Message-ID: <540DEC90.4020907@canonical.com>
Date: Mon, 08 Sep 2014 12:51:12 -0500
From: Chris J Arges <chris.j.arges@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Satoru Takeuchi <satoru.takeuchi@gmail.com>
CC: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ktest: add ability to skip during BISECT_MANUAL
References: <1409164021-2136-1-git-send-email-chris.j.arges@canonical.com>	<CAMym5wtmgsAUP6C-eYgMKJcbiPCUVJ-jZW0PFtv4Mwvr3S9jdw@mail.gmail.com> <CAMym5wtXPOd+5FQiXatpnM-TLkyabA=ZV6aj=wxe-=Bn83B5qw@mail.gmail.com>
In-Reply-To: <CAMym5wtXPOd+5FQiXatpnM-TLkyabA=ZV6aj=wxe-=Bn83B5qw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Satoru,

Thanks for the review.

Steven,

When you have time, let me know if there are any issues with this being
applied.

--chris j arges

On 08/30/2014 08:06 AM, Satoru Takeuchi wrote:
> Hi Chris,
> 
> Sorry for late reply.
> 
> 2014-08-28 3:26 GMT+09:00 Chris J Arges <chris.j.arges@canonical.com>:
> 
>> When doing a manual bisect, a build can fail or a test can be inconclusive.
>> In these cases it would be helpful to be able to skip the test entirely.
>>
>> Signed-off-by: Chris J Arges <chris.j.arges@canonical.com>
> 
> It look good to me.
> 
> Reviewed-by: Satoru Takeuchi <satoru.takeuchi@gmail.com>
> 
> Thanks,
> Satoru
> 
>>
>> ---
>>  tools/testing/ktest/ktest.pl | 6 ++++--
>>  1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
>> index 55ab700..72010f4 100755
>> --- a/tools/testing/ktest/ktest.pl
>> +++ b/tools/testing/ktest/ktest.pl
>> @@ -2336,15 +2336,17 @@ sub success {
>>
>>  sub answer_bisect {
>>      for (;;) {
>> -       doprint "Pass or fail? [p/f]";
>> +       doprint "Pass, fail, or skip? [p/f/s]";
>>         my $ans = <STDIN>;
>>         chomp $ans;
>>         if ($ans eq "p" || $ans eq "P") {
>>             return 1;
>>         } elsif ($ans eq "f" || $ans eq "F") {
>>             return 0;
>> +       } elsif ($ans eq "s" || $ans eq "S") {
>> +           return -1;
>>         } else {
>> -           print "Please answer 'P' or 'F'\n";
>> +           print "Please answer 'p', 'f', or 's'\n";
>>         }
>>      }
>>  }
>> --
>> 1.9.1
>>
> 

