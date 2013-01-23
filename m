Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754308Ab3AWI35 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 03:29:57 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:49995 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753415Ab3AWI34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 03:29:56 -0500
MIME-Version: 1.0
In-Reply-To: <50FEAAC6.3090409@itwm.fraunhofer.de>
References: <20130122133434.2543274.86646.stgit@fsdevel3>
	<CAAxaTiOCLyNJt0Bmqg+7t1knByKfSUpiCDCGm85vtHveDJDzGw@mail.gmail.com>
	<50FEAAC6.3090409@itwm.fraunhofer.de>
Date: Wed, 23 Jan 2013 09:29:55 +0100
X-Google-Sender-Auth: Z_7_7aTQXD-0xFlyRPXgDTaaYnw
Message-ID: <CAAxaTiPYFccAfmXG6jvO5+aLreyiHDQqdTajgqtVJ1vCH0zoyw@mail.gmail.com>
Subject: Re: [PATCH 1/2] coccicheck: Allow the user to give a VERBOSE= argument
From: Nicolas Palix <nicolas.palix@imag.fr>
To: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Cc: linux-kernel@vger.kernel.org, Julia Lawall <Julia.Lawall@lip6.fr>,
        cocci@systeme.lip6.fr, Michal Marek <mmarek@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jan 22, 2013 at 4:05 PM, Bernd Schubert
<bernd.schubert@itwm.fraunhofer.de> wrote:
> Hello Nicolas,
>
>
> On 01/22/2013 03:31 PM, Nicolas Palix wrote:
>>
>> Hi,
>>
>> Thank you Bernd for your proposition.
>>
>> I added Michal in CC, who is responsible for the integration.
>
>
> Oh, sorry, I CCed everyone, but forgot Michal.

Michal, should we consider adding you to the MAINTAINERS of Coccinelle ?

>
>
>>
>> I was wondering if the V variable which already exists would not be better
>> than introducing a new variable. Bernd, is there any reason to not use V ?
>
>
> I'm fine using 'V' either.

OK. Could you resubmit with V, please ?

>
>
>>
>> Your patch also remove the check of the ONLINE variable. In doing so,
>> I think that your patch will badly interfere with the online checking
>> performed with the C variable. Am I missing something ?
>
>
> Hmm, I probably should have told in the patch description that verbosity
> defaults to 0 now. Shall I revert or make an extra patch for that? With the
> current patch and ONLINE != 0 nothing will change.

I am personally fine with cutting off the verbosity by default.
Could you add a comment on how to turn it on in the initial
message of the ONLINE mode which is currently only about false positives,
and add few words in the change log ?

About your other patch, could you resubmit it with V too ?

Thanks.

Regards,

>
>
> Cheers,
> Bernd
>
>
>
>>
>> Regards,
>>
>> On Tue, Jan 22, 2013 at 2:34 PM, Bernd Schubert
>> <bernd.schubert@itwm.fraunhofer.de> wrote:
>>>
>>> Simply running "make coccicheck" returns very verbose output and warnings
>>> might not be noticed.  Allow the user to set the verbosity level.
>>>
>>>
>>> Signed-off-by: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
>>> CC: Julia Lawall <Julia.Lawall@lip6.fr>
>>> CC: Nicolas Palix <nicolas.palix@imag.fr>
>>> CC: cocci@systeme.lip6.fr
>>> ---
>>>   scripts/coccicheck |    8 +++++++-
>>>   1 file changed, 7 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/scripts/coccicheck b/scripts/coccicheck
>>> index 1a49d1c..eab0b00 100755
>>> --- a/scripts/coccicheck
>>> +++ b/scripts/coccicheck
>>> @@ -2,6 +2,12 @@
>>>
>>>   SPATCH="`which ${SPATCH:=spatch}`"
>>>
>>> +if [ -z "$VERBOSE" ] ; then
>>> +       RUN_VERBOSE=0
>>> +else
>>> +       RUN_VERBOSE=$VERBOSE
>>> +fi
>>> +
>>>   if [ "$C" = "1" -o "$C" = "2" ]; then
>>>       ONLINE=1
>>>
>>> @@ -55,7 +61,7 @@ coccinelle () {
>>>   #
>>>   #    $SPATCH -D $MODE $FLAGS -parse_cocci $COCCI $OPT > /dev/null
>>>
>>> -    if [ "$ONLINE" = "0" ] ; then
>>> +    if [ "$RUN_VERBOSE" != "0" ] ; then
>>>
>>>          FILE=`echo $COCCI | sed "s|$srctree/||"`
>>>
>>>
>>
>>
>>
>



-- 
Nicolas Palix
