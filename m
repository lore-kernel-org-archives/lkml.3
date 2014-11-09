Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751040AbaKIFA4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 00:00:56 -0500
Received: from mga03.intel.com ([134.134.136.65]:61962 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714AbaKIFAz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 00:00:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="485830973"
Message-ID: <545EF505.7040101@linux.intel.com>
Date: Sat, 08 Nov 2014 21:00:53 -0800
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Josh Triplett <josh@joshtriplett.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scripts/ksize: Add kernel build size report
References: <eda7fd84192e80829af62db0a6debe6f1987f98b.1415488698.git.dvhart@linux.intel.com> <20141109032630.GB1026@thin>
In-Reply-To: <20141109032630.GB1026@thin>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/8/14 19:26, Josh Triplett wrote:
> On Sat, Nov 08, 2014 at 03:18:18PM -0800, Darren Hart wrote:
>> ksize generates hierarchical build size reports from vmlinux, *.o, and
>> built-in.o files.
>>
>> ksize is useful in preparing minimal configurations and comparing
>> similar configurations across kernel versions.
>>
>> Signed-off-by: Darren Hart <dvhart@linux.intel.com>
>> Cc: Josh Triplett <josh@joshtriplett.org>
> 
> One comment below; with that addressed:
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> 
>> +def main(argv):
>> +    try:
>> +        opts, args = getopt.getopt(argv[1:], "dh", ["help"])
>> +    except getopt.GetoptError, err:
>> +        print '%s' % str(err)
>> +        usage()
>> +        return 2
>> +
>> +    driver_detail = False
>> +    for o, a in opts:
>> +        if o == '-d':
>> +            driver_detail = True
>> +        elif o in ('-h', '--help'):
>> +            usage()
>> +            return 0
>> +        else:
>> +            assert False, "unhandled option"
>> +
>> +    cols = term_width()
>> +
>> +    # Determine kernel version
>> +    p = Popen("strings vmlinux | grep 'Linux version' | cut -d ' ' -f 3",
>> +              shell=True, stdout=PIPE, stderr=PIPE)
>> +    version = p.communicate()[0].strip()
> 
> This seems like a very fragile, Perl-y way to obtain the kernel version.
> 
> I'd suggest either not including the version (just as bloat-o-meter
> doesn't), or parsing it out using objdump -h -t and file offsetting
> (looking for the offset and size of linux_banner).  Personally I'd go
> with the former.

I agree it's a hack, but it isn't a performance sensitive area and I
couldn't see spending the time to calculate offsets and such to save a
couple seconds for something like this. There are more advanced
approaches to extracting bits of information from vmlinux, such as
scripts/extract-ikconfig. I suppose something along those lines could be
created.

As to fragile, I have not tested every version, but this technique has
been used at least as far back as 2.6.24 [1], which seem fairly stable
to me.

Personally, I think it's nice to have. But, if nobody chimes in asking
to keep it, or with a better way to retrieve it, I can resend with it
removed.

Thanks Josh :-)

1.
http://plastilinux.blogspot.com/2009/11/how-to-know-version-of-kernel-without.html
(A slightly faster hack)

-- 
Darren Hart
Intel Open Source Technology Center
