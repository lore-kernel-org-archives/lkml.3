Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167AbaB0UYo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 15:24:44 -0500
Received: from smtp4.epfl.ch ([128.178.224.219]:59846 "EHLO smtp4.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751290AbaB0UYm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 15:24:42 -0500
Message-ID: <530F9F03.40803@epfl.ch>
Date: Thu, 27 Feb 2014 21:24:35 +0100
From: Florian Vaussard <florian.vaussard@epfl.ch>
Reply-To: florian.vaussard@epfl.ch
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Andy Whitcroft <apw@canonical.com>, Rob Herring <robh@kernel.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] checkpatch: fix spurious vendor compatible warnings
References: <1393531019-25134-1-git-send-email-florian.vaussard@epfl.ch> <1393531808.24588.119.camel@joe-AO722>
In-Reply-To: <1393531808.24588.119.camel@joe-AO722>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 02/27/2014 09:10 PM, Joe Perches wrote:
> On Thu, 2014-02-27 at 20:56 +0100, Florian Vaussard wrote:
>> With a compatible string like
>>
>> compatible = "foo";
>>
>> checkpatch will currently try to find "foo" in  vendor-prefixes.txt,
>> which is wrong since the vendor prefix is empty in this specific case.
>>
>> Skip the vendor test if the compatible is not like
>>
>> compatible = "vendor,something";
>>
>> Signed-off-by: Florian Vaussard <florian.vaussard@epfl.ch>
>> ---
>>  scripts/checkpatch.pl | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
>> index 464dcef..35ec185 100755
>> --- a/scripts/checkpatch.pl
>> +++ b/scripts/checkpatch.pl
>> @@ -2058,6 +2058,7 @@ sub process {
>>  				my $vendor = $compat;
>>  				my $vendor_path = $dt_path . "vendor-prefixes.txt";
>>  				next if (! -f $vendor_path);
>> +				next if not $vendor =~ /^[a-zA-Z0-9]+\,.*/;
>>  				$vendor =~ s/^([a-zA-Z0-9]+)\,.*/$1/;
>>  				`grep -Eq "$vendor" $vendor_path`;
>>  				if ( $? >> 8 ) {
> 
> Some vendor names have dashes.
> I don't know if underscores are allowed.
> 
> $ grep -rP --include=*.[ch] -oh "compatible\s*=\s*\"[^,]+,\w" * | \
>   sed -r -e 's/\s//g' -e 's/,.$//' | sort | uniq -c | grep "[_-]"
>       1 compatible="active-semi
>       8 compatible="asahi-kasei
> 

Good catch. In ePAPR v1.1, I could not find any strict requirement. It
is just saying:

The recommended format is “manufacturer,model”, where manufacturer is a
string describing the name of the manufacturer (such as a stock ticker
symbol), and model specifies the model number.

If I am not mistaking, the stock ticker symbol will not contain exotic
characters, but it is not always available. So we should probably add
the '-. I am not sure for the '_'.

Florian
