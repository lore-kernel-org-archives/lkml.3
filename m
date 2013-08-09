Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756769Ab3HIMak (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 08:30:40 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:46694 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787Ab3HIMaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 08:30:39 -0400
Date: Fri, 9 Aug 2013 14:30:34 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Johannes Thumshirn <johannes.thumshirn@men.de>
Cc: Tim Bird <tim.bird@am.sony.com>, linux-kernel@vger.kernel.org,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Michal Marek <mmarek@suse.cz>
Subject: Re: [PATCH] kconfig: Make diffconfig work with Python 3
Message-ID: <20130809123034.GA5794@merkur.ravnborg.org>
References: <20130809122655.GA7108@jtlinux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130809122655.GA7108@jtlinux>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Johannes.

Can you please resnd and include Michal Marek + kbuild mailing list.
Both are added to this mail so you have the addresses.

	Sam

On Fri, Aug 09, 2013 at 02:27:02PM +0200, Johannes Thumshirn wrote:
> Adjust diffconfig to run cleanly on Python 3 (Tested with 3.3.2) and
> Python 2 (2.7.5)
> 
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@men.de>
> ---
>  scripts/diffconfig |   26 +++++++++++++-------------
>  1 file changed, 13 insertions(+), 13 deletions(-)
> 
> diff --git a/scripts/diffconfig b/scripts/diffconfig
> index b91f3e3..dd0e75b 100755
> --- a/scripts/diffconfig
> +++ b/scripts/diffconfig
> @@ -10,7 +10,7 @@
>  import sys, os
> 
>  def usage():
> -    print """Usage: diffconfig [-h] [-m] [<config1> <config2>]
> +    print ("""Usage: diffconfig [-h] [-m] [<config1> <config2>]
> 
>  Diffconfig is a simple utility for comparing two .config files.
>  Using standard diff to compare .config files often includes extraneous and
> @@ -33,7 +33,7 @@ Example usage:
>   EXT2_FS  y -> n
>   LOG_BUF_SHIFT  14 -> 16
>   PRINTK_TIME  n -> y
> -"""
> +""")
>      sys.exit(0)
> 
>  # returns a dictionary of name/value pairs for config items in the file
> @@ -54,23 +54,23 @@ def print_config(op, config, value, new_value):
>      if merge_style:
>          if new_value:
>              if new_value=="n":
> -                print "# CONFIG_%s is not set" % config
> +                print("# CONFIG_%s is not set" % config)
>              else:
> -                print "CONFIG_%s=%s" % (config, new_value)
> +                print("CONFIG_%s=%s" % (config, new_value))
>      else:
>          if op=="-":
> -            print "-%s %s" % (config, value)
> +            print("-%s %s" % (config, value))
>          elif op=="+":
> -            print "+%s %s" % (config, new_value)
> +            print("+%s %s" % (config, new_value))
>          else:
> -            print " %s %s -> %s" % (config, value, new_value)
> +            print(" %s %s -> %s" % (config, value, new_value))
> 
>  def main():
>      global merge_style
> 
>      # parse command line args
>      if ("-h" in sys.argv or "--help" in sys.argv):
> -	usage()
> +        usage()
> 
>      merge_style = 0
>      if "-m" in sys.argv:
> @@ -79,13 +79,13 @@ def main():
> 
>      argc = len(sys.argv)
>      if not (argc==1 or argc == 3):
> -        print "Error: incorrect number of arguments or unrecognized option"
> +        print("Error: incorrect number of arguments or unrecognized option")
>          usage()
> 
>      if argc == 1:
>          # if no filenames given, assume .config and .config.old
>          build_dir=""
> -        if os.environ.has_key("KBUILD_OUTPUT"):
> +        if 'KBUILD_OUTPUT' in os.environ:
>              build_dir = os.environ["KBUILD_OUTPUT"]+"/"
> 
>          configa_filename = build_dir + ".config.old"
> @@ -94,8 +94,8 @@ def main():
>          configa_filename = sys.argv[1]
>          configb_filename = sys.argv[2]
> 
> -    a = readconfig(file(configa_filename))
> -    b = readconfig(file(configb_filename))
> +    a = readconfig(open(configa_filename))
> +    b = readconfig(open(configb_filename))
> 
>      # print items in a but not b (accumulate, sort and print)
>      old = []
> @@ -121,7 +121,7 @@ def main():
> 
>      # now print items in b but not in a
>      # (items from b that were in a were removed above)
> -    new = b.keys()
> +    new = list(b.keys())
>      new.sort()
>      for config in new:
>          print_config("+", config, None, b[config])
> --
> 1.7.9.5
