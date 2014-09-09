Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266AbaIIQlj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 12:41:39 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:34713 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840AbaIIQli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 12:41:38 -0400
Message-ID: <540F17E5.1020701@gmail.com>
Date: Tue, 09 Sep 2014 17:08:21 +0200
From: Nitin Kuppelur <nitinkuppelur@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: akpm@linux-foundation.org, josh@joshtriplett.org, robh@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scripts: checkpatch.pl add warning for dummy label
References: <1410270855-6639-1-git-send-email-nitinkuppelur@gmail.com> <1410277380.12560.38.camel@joe-AO725>
In-Reply-To: <1410277380.12560.38.camel@joe-AO725>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

Thanks for feedback.

The idea of adding new warning came from the review comments from
one of my PATCH, where it was suggested by few reviewers to remove such
"Do-Nothing" labels. But current checkpatch.pl does not warn about that.

[PATCH]
http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg720639.html


Regards,
Nitin

On 09/09/2014 05:43 PM, Joe Perches wrote:
> On Tue, 2014-09-09 at 15:54 +0200, Nitin Kuppelur wrote:
>> Added new warning DUMMY_LABEL in checkpatch.pl. This warns
>> if return statement is encountered just after goto label target
>> like "out:". In such scenario it is best to call "return;" directly
>> instead of "goto out;"
> 
> I'm not sure this is desired/correct.
> 
> There are many functions written like:
> 
> return_type foo(...)
> {
> 	[some initialization...]
> 
> 	err = some_test(...);
> 	if (err)
> 		goto out;
> 
> 	[...]
> 
> out:
> 	[some cleanup...]
> 	return err;
> }
> 
> In many cases, a void function is a simple
> variant of a non-void function and many people
> like to see the same code "shape" in functions,
> just without the init and cleanup bits.
> 
>> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> []
>> @@ -3798,10 +3798,14 @@ sub process {
>>  		if ($sline =~ /^[ \+]}\s*$/ &&
>>  		    $prevline =~ /^\+\treturn\s*;\s*$/ &&
>>  		    $linenr >= 3 &&
>> -		    $lines[$linenr - 3] =~ /^[ +]/ &&
>> -		    $lines[$linenr - 3] !~ /^[ +]\s*$Ident\s*:/) {
>> -			WARN("RETURN_VOID",
>> -			     "void function return statements are not generally useful\n" . $hereprev);
>> +		    $lines[$linenr - 3] =~ /^[ +]/) {
>> +			if ($lines[$linenr - 3] !~ /^[ +]\s*$Ident\s*:/) {
>> +				WARN("RETURN_VOID",
>> +				     "void function return statements are not generally useful\n" . $hereprev);
>> +			} elsif ($lines[$linenr - 3] =~ /^[ +]\s*$Ident\s*:/) {
>> +				WARN("DUMMY_LABEL",
>> +				     "labels doing nothing are not generally useful\n" . $hereprev);
>> +			}
>>                 }
>>  
>>  # if statements using unnecessary parentheses - ie: if ((foo == bar))
> 
> 
> 
