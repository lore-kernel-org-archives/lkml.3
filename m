Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754AbbAGOtx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 09:49:53 -0500
Received: from out114-136.biz.mail.alibaba.com ([205.204.114.136]:45311 "EHLO
	out21.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751800AbbAGOtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 09:49:51 -0500
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.0742297|-1;FP=0|0|0|0|0|-1|-1|-1;HT=r41g03015;MF=gang.chen@sunrus.com.cn;PH=DS;RN=6;RT=6;SR=0;
Message-ID: <54AD4677.6040009@sunrus.com.cn>
Date: Wed, 07 Jan 2015 22:45:11 +0800
From: Chen Gang S <gang.chen@sunrus.com.cn>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
CC: Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        holzheu@linux.vnet.ibm.com, linux-s390@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] s390: include: timex: Use macro CLOCK_STORE_SIZE instead
 of hard code number
References: <54A55954.6000002@sunrus.com.cn> <20150102094625.GA4059@osiris> <54A76584.6020700@sunrus.com.cn> <20150105095948.0612e7bc@mschwide>
In-Reply-To: <20150105095948.0612e7bc@mschwide>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2015 04:59 PM, Martin Schwidefsky wrote:
> On Sat, 03 Jan 2015 11:44:04 +0800
> Chen Gang <gang.chen@sunrus.com.cn> wrote:
> 
>>
>> Thank you for your work.
>>
>> In honest, originally, I was not sure whether it would cause bug (do not
>> know gcc would generic incorrect code for it). :-)
> 
> Even if the code happened to be correct it does not matter. The intention
> of the sizeof() has been to get to the correct 16, not 8. The fix is
> fine as it is.
> 

Excuse me, my English is not quite well, I am not quite sure about what
you said (might misunderstand what you said), so I provide the related
information below for confirmation, please check, thanks.

sizeof(clk) is for a pointer, not for an array (for C language, it
treats array parameter as a pointer), the related demo is below:

  [root@localhost test]# cat ./test.c
  #include <stdio.h>
  
  static inline void get_tod_clock_ext(char clk[16])
  {
  	typedef struct { char _[sizeof(clk)]; } addrtype;
  
  	printf("\nsize: %ld\n", sizeof(addrtype));
  }
  
  int main()
  {
  	char clk[16];
  
  	get_tod_clock_ext(clk);
  	return 0;
  }
  [root@localhost test]# cc -Wall -O2 -o test test.c
  [root@localhost test]# ./test 
  
  size: 8
  [root@localhost test]# cc -v
  Using built-in specs.
  COLLECT_GCC=cc
  COLLECT_LTO_WRAPPER=/usr/libexec/gcc/x86_64-redhat-linux/4.8.3/lto-wrapper
  Target: x86_64-redhat-linux
  Configured with: ../configure --prefix=/usr --mandir=/usr/share/man --infodir=/usr/share/info --with-bugurl=http://bugzilla.redhat.com/bugzilla --enable-bootstrap --enable-shared --enable-threads=posix --enable-checking=release --with-system-zlib --enable-__cxa_atexit --disable-libunwind-exceptions --enable-gnu-unique-object --enable-linker-build-id --with-linker-hash-style=gnu --enable-languages=c,c++,objc,obj-c++,java,fortran,ada,go,lto --enable-plugin --enable-initfini-array --enable-java-awt=gtk --disable-dssi --with-java-home=/usr/lib/jvm/java-1.5.0-gcj-1.5.0.0/jre --enable-libgcj-multifile --enable-java-maintainer-mode --with-ecj-jar=/usr/share/java/eclipse-ecj.jar --disable-libjava-multilib --with-isl=/builddir/build/BUILD/gcc-4.8.3-20140624/obj-x86_64-redhat-linux/isl-install --with-cloog=/builddir/build/BUILD/gcc-4.8.3-20140624/obj-x86_64-redhat-linux/cloog-install --with-tune=generic --with-arch_32=i686 --build=x86_64-redhat-linux
  Thread model: posix
  gcc version 4.8.3 20140624 (Red Hat 4.8.3-1) (GCC) 
  [root@localhost test]# 


Thanks.
-- 
Open, share, and attitude like air, water, and life which God blessed.
