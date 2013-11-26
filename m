Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932347Ab3KZRLa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 12:11:30 -0500
Received: from mail-ve0-f178.google.com ([209.85.128.178]:59300 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932323Ab3KZRL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 12:11:27 -0500
MIME-Version: 1.0
In-Reply-To: <1385484225.20100.58.camel@joe-AO722>
References: <1385481675-26675-1-git-send-email-robherring2@gmail.com>
	<1385484225.20100.58.camel@joe-AO722>
Date: Tue, 26 Nov 2013 11:11:26 -0600
Message-ID: <CAL_JsqKgUQZT4g3fgPe-h8G-zWb1gnfxgT20BDrL+zS5u4URzg@mail.gmail.com>
Subject: Re: [PATCH] checkpatch: add DT compatible string documentation check
From: Rob Herring <robherring2@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@linaro.org>,
        Andy Whitcroft <apw@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26, 2013 at 10:43 AM, Joe Perches <joe@perches.com> wrote:
> On Tue, 2013-11-26 at 10:01 -0600, Rob Herring wrote:
>> From: Rob Herring <rob.herring@calxeda.com>
>
> Hi Rob.
>
>> This adds a simple check that any compatible strings in DeviceTree dts
>> files are present in Documentation/devicetree/bindings. This should be a
>> temporary check until we have more sophisticated binding schema checking.
> []
>> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> []
>> @@ -2034,6 +2034,21 @@ sub process {
>>                            "Use of $flag is deprecated, please use \`$replacement->{$flag} instead.\n" . $herecurr) if ($replacement->{$flag});
>>               }
>>
>> +# check for compatible documentation
>> +             if ($realfile =~ /\.dts/ && $rawline =~ /\+\s*compatible\s*=/) {
>> +                     my @compats = $rawline =~ /\"([a-zA-Z0-9\-\,]+)\"/g;
>
> I believe there needs to be a \+\. in the brackets
> for lines like:
>
> arch/c6x/boot/dts/tms320c6678.dtsi: compatible = "ti,c64x+timer64";

I think we don't really want '+' (or '_') in compatible strings. That
would really a check against the documentation versus whether the dts
matches the documentation. So I probably should add a separate check
on use of documented, but deprecated compatible strings. Ideally, that
check would be on the binding doc, but since they are unstructured
currently, we'd have to do it on dts files.

> and
> arch/powerpc/boot/dts/mpc8313erdb.dts: compatible = "fsl,sec2.2", "fsl,sec2.1",

Yes, indeed.

Rob
