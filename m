Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753776Ab3AVPFt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 10:05:49 -0500
Received: from mailgw1.uni-kl.de ([131.246.120.220]:42752 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248Ab3AVPFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 10:05:48 -0500
Message-ID: <50FEAAC6.3090409@itwm.fraunhofer.de>
Date: Tue, 22 Jan 2013 16:05:42 +0100
From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Nicolas Palix <nicolas.palix@imag.fr>
CC: linux-kernel@vger.kernel.org, Julia Lawall <Julia.Lawall@lip6.fr>,
        cocci@systeme.lip6.fr, Michal Marek <mmarek@suse.cz>
Subject: Re: [PATCH 1/2] coccicheck: Allow the user to give a VERBOSE= argument
References: <20130122133434.2543274.86646.stgit@fsdevel3> <CAAxaTiOCLyNJt0Bmqg+7t1knByKfSUpiCDCGm85vtHveDJDzGw@mail.gmail.com>
In-Reply-To: <CAAxaTiOCLyNJt0Bmqg+7t1knByKfSUpiCDCGm85vtHveDJDzGw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ITWM-CharSet: UTF-8
X-ITWM-Scanned-By: mail2.itwm.fhg.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Nicolas,

On 01/22/2013 03:31 PM, Nicolas Palix wrote:
> Hi,
>
> Thank you Bernd for your proposition.
>
> I added Michal in CC, who is responsible for the integration.

Oh, sorry, I CCed everyone, but forgot Michal.

>
> I was wondering if the V variable which already exists would not be better
> than introducing a new variable. Bernd, is there any reason to not use V ?

I'm fine using 'V' either.

>
> Your patch also remove the check of the ONLINE variable. In doing so,
> I think that your patch will badly interfere with the online checking
> performed with the C variable. Am I missing something ?

Hmm, I probably should have told in the patch description that verbosity 
defaults to 0 now. Shall I revert or make an extra patch for that? With 
the current patch and ONLINE != 0 nothing will change.


Cheers,
Bernd


>
> Regards,
>
> On Tue, Jan 22, 2013 at 2:34 PM, Bernd Schubert
> <bernd.schubert@itwm.fraunhofer.de> wrote:
>> Simply running "make coccicheck" returns very verbose output and warnings
>> might not be noticed.  Allow the user to set the verbosity level.
>>
>>
>> Signed-off-by: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
>> CC: Julia Lawall <Julia.Lawall@lip6.fr>
>> CC: Nicolas Palix <nicolas.palix@imag.fr>
>> CC: cocci@systeme.lip6.fr
>> ---
>>   scripts/coccicheck |    8 +++++++-
>>   1 file changed, 7 insertions(+), 1 deletion(-)
>>
>> diff --git a/scripts/coccicheck b/scripts/coccicheck
>> index 1a49d1c..eab0b00 100755
>> --- a/scripts/coccicheck
>> +++ b/scripts/coccicheck
>> @@ -2,6 +2,12 @@
>>
>>   SPATCH="`which ${SPATCH:=spatch}`"
>>
>> +if [ -z "$VERBOSE" ] ; then
>> +       RUN_VERBOSE=0
>> +else
>> +       RUN_VERBOSE=$VERBOSE
>> +fi
>> +
>>   if [ "$C" = "1" -o "$C" = "2" ]; then
>>       ONLINE=1
>>
>> @@ -55,7 +61,7 @@ coccinelle () {
>>   #
>>   #    $SPATCH -D $MODE $FLAGS -parse_cocci $COCCI $OPT > /dev/null
>>
>> -    if [ "$ONLINE" = "0" ] ; then
>> +    if [ "$RUN_VERBOSE" != "0" ] ; then
>>
>>          FILE=`echo $COCCI | sed "s|$srctree/||"`
>>
>>
>
>
>

