Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759986Ab3ICNIO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 09:08:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33880 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759927Ab3ICNIN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 09:08:13 -0400
Message-ID: <5225DF39.8000105@suse.cz>
Date: Tue, 03 Sep 2013 15:08:09 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Johannes Thumshirn <johannes.thumshirn@men.de>
Cc: Tim Bird <tbird20d@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] kconfig: Make diffconfig work with Python 3
References: <20130809122655.GA7108@jtlinux> <CA+bK7J4g04AumqDSznWbxeAUCrrV-ewMN=YenFSc=HQHNVae4Q@mail.gmail.com> <20130829151037.GB32730@jtlinux>
In-Reply-To: <20130829151037.GB32730@jtlinux>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.8.2013 17:10, Johannes Thumshirn wrote:
> On Wed, Aug 28, 2013 at 07:29:53AM -0700, Tim Bird wrote:
>> On Fri, Aug 9, 2013 at 5:27 AM, Johannes Thumshirn
>> <johannes.thumshirn@men.de> wrote:
>>> Adjust diffconfig to run cleanly on Python 3 (Tested with 3.3.2) and
>>> Python 2 (2.7.5)
>>>
>>> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@men.de>
>>> ---
>>>  scripts/diffconfig |   26 +++++++++++++-------------
>>>  1 file changed, 13 insertions(+), 13 deletions(-)
>>>
>>> diff --git a/scripts/diffconfig b/scripts/diffconfig
>>> index b91f3e3..dd0e75b 100755
>>> --- a/scripts/diffconfig
>>> +++ b/scripts/diffconfig
>>> @@ -10,7 +10,7 @@
>>>  import sys, os
>>>
>>>  def usage():
>>> -    print """Usage: diffconfig [-h] [-m] [<config1> <config2>]
>>> +    print ("""Usage: diffconfig [-h] [-m] [<config1> <config2>]
>>>
>>>  Diffconfig is a simple utility for comparing two .config files.
>>>  Using standard diff to compare .config files often includes extraneous and
>>> @@ -33,7 +33,7 @@ Example usage:
>>>   EXT2_FS  y -> n
>>>   LOG_BUF_SHIFT  14 -> 16
>>>   PRINTK_TIME  n -> y
>>> -"""
>>> +""")
>>>      sys.exit(0)
>>>
>>>  # returns a dictionary of name/value pairs for config items in the file
>>> @@ -54,23 +54,23 @@ def print_config(op, config, value, new_value):
>>>      if merge_style:
>>>          if new_value:
>>>              if new_value=="n":
>>> -                print "# CONFIG_%s is not set" % config
>>> +                print("# CONFIG_%s is not set" % config)
>>>              else:
>>> -                print "CONFIG_%s=%s" % (config, new_value)
>>> +                print("CONFIG_%s=%s" % (config, new_value))
>>>      else:
>>>          if op=="-":
>>> -            print "-%s %s" % (config, value)
>>> +            print("-%s %s" % (config, value))
>>>          elif op=="+":
>>> -            print "+%s %s" % (config, new_value)
>>> +            print("+%s %s" % (config, new_value))
>>>          else:
>>> -            print " %s %s -> %s" % (config, value, new_value)
>>> +            print(" %s %s -> %s" % (config, value, new_value))
>>>
>>>  def main():
>>>      global merge_style
>>>
>>>      # parse command line args
>>>      if ("-h" in sys.argv or "--help" in sys.argv):
>>> -       usage()
>>> +        usage()
>>>
>>>      merge_style = 0
>>>      if "-m" in sys.argv:
>>> @@ -79,13 +79,13 @@ def main():
>>>
>>>      argc = len(sys.argv)
>>>      if not (argc==1 or argc == 3):
>>> -        print "Error: incorrect number of arguments or unrecognized option"
>>> +        print("Error: incorrect number of arguments or unrecognized option")
>>>          usage()
>>>
>>>      if argc == 1:
>>>          # if no filenames given, assume .config and .config.old
>>>          build_dir=""
>>> -        if os.environ.has_key("KBUILD_OUTPUT"):
>>> +        if 'KBUILD_OUTPUT' in os.environ:
>>>              build_dir = os.environ["KBUILD_OUTPUT"]+"/"
>>>
>>>          configa_filename = build_dir + ".config.old"
>>> @@ -94,8 +94,8 @@ def main():
>>>          configa_filename = sys.argv[1]
>>>          configb_filename = sys.argv[2]
>>>
>>> -    a = readconfig(file(configa_filename))
>>> -    b = readconfig(file(configb_filename))
>>> +    a = readconfig(open(configa_filename))
>>> +    b = readconfig(open(configb_filename))
>>>
>>>      # print items in a but not b (accumulate, sort and print)
>>>      old = []
>>> @@ -121,7 +121,7 @@ def main():
>>>
>>>      # now print items in b but not in a
>>>      # (items from b that were in a were removed above)
>>> -    new = b.keys()
>>> +    new = list(b.keys())
>>>      new.sort()
>>>      for config in new:
>>>          print_config("+", config, None, b[config])
>>> --
>>> 1.7.9.5
>>
>> Sorry I missed this earlier.  My new e-mail is tim.bird@sonymobile.com, and
>> my old am.sony.com address doesn't work any more.
>>
>> Thanks - this looks great.
>>
>> Acked-by Tim Bird <tim.bird@sonymobile.com>
>>
>>  -- Tim Bird
>> Senior Software Engineer, Sony Mobile
>> Architecture Group Chair, CE Workgroup, Linux Foundation
> 
> Is there any comments from the kbuild maintainers?

I merged a nearly identical patch by Mike Pagano
(http://www.spinics.net/lists/linux-kbuild/msg08503.html), seems like
you guys had the same idea at the same time.

Michal
